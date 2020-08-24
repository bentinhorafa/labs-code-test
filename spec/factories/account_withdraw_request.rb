FactoryBot.define do
  factory :account_withdraw_request do
    amount { 100.0 }
    cash_possibilities { '2x50|1x50-2x20-5x2' }
    account { create(:account) }
  end
end
