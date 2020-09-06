class AccountTransferService
  attr_reader :token, :destiny_branch, :destiny_account_number, :amount

  def initialize(token:, destiny_branch:, destiny_account_number:, amount:)
    @token = token
    @destiny_branch = destiny_branch
    @destiny_account_number = destiny_account_number
    @amount = amount
  end

  def self.transfer(...)
    new(...).transfer
  end

  def transfer
    return if destiny_account.blank?
    return unless origin_balance_support_debit?
    return if destiny_limit_reached?

    create_transactions
  end

  private

  def origin_account
    @origin_account = User.find_by(token: token).account
  end

  def destiny_account
    @destiny_account = Account.find_by(branch: destiny_branch,
                                       account_number: destiny_account_number)
  end

  def transfer_amount
    @transfer_amount = amount.abs
  end

  def create_transactions
    ActiveRecord::Base.transaction do
      AccountTransaction.create(
        account: origin_account,
        amount: -transfer_amount,
        transaction_type: 'transfer'
      )

      update_balance(origin_account, -transfer_amount)

      AccountTransaction.create(
        account: destiny_account,
        amount: transfer_amount,
        transaction_type: 'transfer'
      )

      update_balance(destiny_account, transfer_amount)
    end
  end

  def update_balance(account, value)
    balance = account.balance

    account.update!(balance: balance + value)
  end

  def origin_balance_support_debit?
    origin_account.balance - transfer_amount >= 0
  end

  def destiny_limit_reached?
    destiny_account.balance + transfer_amount > destiny_account.limit
  end
end
