class User < ApplicationRecord
  has_one :account, dependent: :nullify

  validates :full_name, presence: true, length: { maximum: 200 }
  validates :document,
            presence: true,
            uniqueness: true,
            length: { is: 11 },
            case_sensitive: false
  validates :address, presence: true, length: { maximum: 200 }
  validates :birthday, presence: true
  validates :gender, presence: true, length: { is: 1 }
  validates :password, presence: true, length: { is: 8 }
  validates :token, presence: true, uniqueness: true
end
