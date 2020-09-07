class AccountLimitUpdateService
  TEN_MINUTES = 600

  attr_reader :token, :limit

  def initialize(token:, limit:)
    @token = token
    @limit = limit
  end

  def self.update(...)
    new(...).update
  end

  def update
    return unless update_allowed?

    update_limit
  end

  private

  def user
    @user ||= User.find_by(token: token)
  end

  def account
    @account ||= user.account
  end

  def last_limit_update
    @last_limit_update ||= account.last_limit_update
  end

  def update_allowed?
    time_enough? && balance_less_or_equal_than_limit?
  end

  def time_enough?
    past_time = Time.zone.now - last_limit_update
    past_time >= TEN_MINUTES
  end

  def balance_less_or_equal_than_limit?
    account.balance <= limit
  end

  def update_limit
    account.update(limit: limit, last_limit_update: Time.zone.now)
  end
end
