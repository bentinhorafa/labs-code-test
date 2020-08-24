class AccountWithdrawRequest < ApplicationRecord
  belongs_to :account
  belongs_to :account_transaction, optional: true

  validates :amount,
            presence: true,
            numericality: { greater_than_or_equal_to: 2.0, even: true }
  validates :cash_possibilities,
            presence: true
end
