class AccountDepositService
  attr_reader :token, :amount

  def initialize(deposit_params)
    @token = deposit_params[:token]
    @amount = deposit_params[:amount]
  end

  def self.deposit(...)
    new(...).deposit
  end

  def deposit
    return if daily_limit_reached?
    return if account_limit_reached?

    create_deposit
  end

  private

  def user
    @user ||= User.find_by(token: token)
  end

  def account
    @account ||= user.account
  end

  def normalized_amount
    @normalized_amount = amount.round(0).to_i.abs
  end

  def account_transactions
    today = Time.zone.today

    @account_transactions = account.account_transactions.deposit.where(
      created_at: today.beginning_of_day..today.end_of_day
    )
  end

  def daily_limit_reached?
    sum_deposits = account_transactions.deposit.sum(:amount).to_f
    sum_deposits + normalized_amount >= 800.0
  end

  def account_limit_reached?
    new_balance = account.balance + normalized_amount
    new_balance >= account.limit
  end

  def balance
    @balance = account.balance
  end

  def create_deposit
    ActiveRecord::Base.transaction do
      account_transaction = AccountTransaction.new(
        account: account,
        amount: normalized_amount
      )

      account_transaction.deposit!

      account.update(balance: balance + normalized_amount) if account_transaction.valid?

      account_transaction.save
      account
    end
  end
end
