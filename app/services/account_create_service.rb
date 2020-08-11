class AccountCreateService
  BRANCH_RANGE = (0..9_999).freeze
  ACCOUNT_NUMBER_RANGE = (0..99_999).freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.create(...)
    new(...).create
  end

  def create
    Account.create(
      branch: rand(BRANCH_RANGE).to_s.rjust(4, '0'),
      account_number: rand(ACCOUNT_NUMBER_RANGE).to_s.rjust(5, '0'),
      limit: rand(1000.0..1800.0).round(2),
      last_limit_update: Time.zone.now,
      balance: 0,
      user: user
    )
  end
end
