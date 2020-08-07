FactoryBot.define do
  factory :account do
    branch { '0123' }
    account_number { '12345' }
    limit { rand(1000.0..1800.0).round(2) }
    last_limit_update { Time.zone.now }
    balance { 0.0 }
    user { create(:user) }
  end
end
