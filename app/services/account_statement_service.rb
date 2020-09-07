class AccountStatementService
  attr_reader :token, :days

  def initialize(token, days = 7)
    @token = token
    @days = days.to_i
  end

  def self.statement(...)
    new(...).statement
  end

  def statement
    return unless days.between?(1, 90)

    transactions_by_period
  end

  private

  def account
    @account ||= User.find_by(token: token).account
  end

  def transactions_by_period
    start_date = normalized_start_date
    end_date = Time.zone.today.end_of_day

    account.account_transactions.where(created_at: start_date..end_date)
  end

  def normalized_start_date
    return Time.zone.today.beginning_of_day if days == 1

    (Time.zone.today - (days - 1).days).beginning_of_day
  end
end
