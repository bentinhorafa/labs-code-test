class WithdrawConfirmService
  class WithdrawRequestIdNotFound < StandardError; end

  attr_reader :account_withdraw_request_id, :possibility

  def initialize(account_withdraw_request_id:, possibility:)
    @account_withdraw_request_id = account_withdraw_request_id
    @possibility = possibility
  end

  def self.confirm(...)
    new(...).confirm
  end

  def confirm
    create_withdraw_transaction
  end

  private

  def account_withdraw_request
    id = account_withdraw_request_id
    @account_withdraw_request ||= AccountWithdrawRequest.find(id)
  rescue
    raise WithdrawRequestIdNotFound, "Withdraw Request ##{id} not found!"
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
end
