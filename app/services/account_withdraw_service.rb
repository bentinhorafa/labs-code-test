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
    return unless valid_amount?
    return unless balance_support_debit?

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
    cash_possibilities = normalized_cash(
      WithdrawPossibilitiesService.new(normalized_amount).call
    )

    account_withdraw_request ||= AccountWithdrawRequest.new(
      account: account,
      amount: normalized_amount,
      cash_possibilities: cash_possibilities
    )

    account_withdraw_request.save if account_withdraw_request.valid?

    account_withdraw_request
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
end
