class Transfer < ApplicationRecord
  belongs_to :origin, class_name: 'Account'
  belongs_to :destiny, class_name: 'Account'
  has_many :account_transactions, dependent: :destroy

  validates :amount,
            presence: true,
            numericality: { greater_than: 0.0 }
end
