class AccountCreateService
  class AccountCreatError < StandardError; end

  BRANCH_RANGE = 0..9999
  ACCOUNT_NUMBER_RANGE = 0..99999

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.create(...)
    new(...).create
  end

  def create
    create_account
  end

  private

  def create_account
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
