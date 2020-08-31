class AccountTransaction < ApplicationRecord
  belongs_to :account
  belongs_to :transfer, optional: true
  has_one :account_withdraw_request, dependent: :destroy

  enum transaction_type: { withdraw: 0, deposit: 1, transfer: 2 }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: true
end
