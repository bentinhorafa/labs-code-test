class AccountTransaction < ApplicationRecord
  belongs_to :account
  belongs_to :transfer, optional: true

  enum type: { withdraw: 0, deposit: 1, transfer: 2 }

  validates :type, presence: true
  validates :amount, presence: true, numericality: true
end
