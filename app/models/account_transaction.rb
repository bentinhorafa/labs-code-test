class AccountTransaction < ApplicationRecord
  belongs_to :account

  enum type: { withdraw: 0, deposit: 1 }

  validates :type, presence: true
  validates :amount, presence: true, numericality: true
end
