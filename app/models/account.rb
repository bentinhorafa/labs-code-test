class Account < ApplicationRecord
  belongs_to :user
  has_many :account_transactions, dependent: :nullify

  validates :branch,
            presence: true,
            case_sensitive: false,
            length: { is: 4 },
            numericality: { only_integer: true }
  validates :account_number,
            presence: true,
            case_sensitive: false,
            uniqueness: { scope: :branch },
            length: { is: 5 },
            numericality: { only_integer: true }
  validates :limit,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.0 }
  validates :last_limit_update, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }
end
