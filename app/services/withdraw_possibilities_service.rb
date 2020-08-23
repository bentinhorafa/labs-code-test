class WithdrawPossibilitiesService
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def self.call(...)
    new(...).call
  end

  def call
    possibilities = if amount >= 20
                      [
                        cash_possibility(value: amount, attempt: true),
                        cash_possibility(value: amount)
                      ]
                    else
                      [cash_possibility(value: amount)]
                    end

    possibilities
  end

  private

  def cash_possibility(total: { '50' => 0, '20' => 0, '2' => 0 }, value:,
                       cashes: [50, 20, 2], attempt: false)
    cash = cashes.shift

    while value >= cash
      total[cash.to_s] += 1
      value -= cash
    end

    if attempt && total[cash.to_s].positive?
      total[cash.to_s] -= 1
      value += cash
      attempt = false
    end

    if value.positive?
      cash_possibility(
        total: total, value: value, cashes: cashes, attempt: attempt
      )
    end

    normalized_option(total)
  end

  def normalized_option(option)
    option.delete_if { |_key, value| value.zero? }

    option
  end
end
