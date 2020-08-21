class AccountTransaction < ApplicationRecord
  belongs_to :account
  belongs_to :transfer, optional: true

  enum transaction_type: { withdraw: 0, deposit: 1, transfer: 2 }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: true
end
