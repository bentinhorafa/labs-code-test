class AccountWithdrawService
  attr_reader :token, :amount

  def initialize(token:, amount:)
    @token = token
    @amount = amount
  end

  def self.withdraw(...)
    new(...).withdraw
  end

  def withdraw
    create_account_withdraw_request
  end

  private

  def user
    @user ||= User.find_by(token: token)
  end

  def account
    @account ||= user.account
  end

  def create_account_withdraw_request
    return unless valid_amount?
    return unless balance_support_debit?

    cash_possibilities = normalized_cash(
      WithdrawPossibilitiesService.new(normalized_amount).call
    )

    account_withdraw_request ||= AccountWithdrawRequest.new(
      account: account,
      amount: normalized_amount,
      cash_possibilities: cash_possibilities
    )

    account_withdraw_request.save if account_withdraw_request.valid?

    build_response(account_withdraw_request)
  end

  def valid_amount?
    normalized_amount.even? && normalized_amount >= 2
  end

  def balance_support_debit?
    account.balance - normalized_amount >= 0
  end

  def normalized_amount
    amount.round(0).to_i
  end

  def normalized_cash(cash)
    cashes = []

    cash.each do |hash|
      temp_cash = []

      hash.each do |k, v|
        temp_cash << "#{v}x#{k}"
      end

      cashes << temp_cash.join('-')
    end

    cashes.join('|')
  end

  def build_response(account_withdraw_request)
    cash_possibilities = account_withdraw_request.cash_possibilities.split('|')
    response_possibilities = normalized_possibilities(cash_possibilities)

    {
      id: account_withdraw_request.id,
      amount: normalized_amount,
      cash_possibilities: response_possibilities
    }
  end

  def normalized_possibilities(cash_possibilities)
    possibilities = []

    cash_possibilities.each do |possibility|
      temp_array = []

      possibility.split('-').each do |quantity_money|
        quantity = quantity_money.split('x').first
        money = quantity_money.split('x').last

        temp_array << "#{quantity} nota(s) de #{money}"
      end

      possibilities << temp_array.join(', ')
    end

    possibilities
  end
end
