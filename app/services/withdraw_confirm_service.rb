class WithdrawConfirmService
  class WithdrawRequestIdNotFound < StandardError; end

  attr_reader :token, :account_withdraw_request, :possibility

  def initialize(token:, account_withdraw_request:, possibility:)
    @token = token
    @account_withdraw_request = account_withdraw_request
    @possibility = possibility
  end

  def self.confirm(...)
    new(...).confirm
  end

  def confirm
    return unless same_user?

    create_withdraw_transaction
  end

  private

  def user
    @user ||= User.find_by(token: token)
  end

  def account
    @account ||= account_withdraw_request.account
  end

  def create_withdraw_transaction
    ActiveRecord::Base.transaction do
      account_transaction = AccountTransaction.create(
        account: account,
        amount: account_withdraw_request.amount
      )

      account_transaction.withdraw!

      update_withdraw_request(account_transaction.id)
      update_balance

      account_transaction
    end
  end

  def update_withdraw_request(account_transaction_id)
    account_withdraw_request.update(
      account_transaction_id: account_transaction_id
    )
  end

  def update_balance
    account.update(balance: account.balance - account_withdraw_request.amount)
  end

  def same_user?
    user == account.user
  end
end
