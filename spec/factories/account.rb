FactoryBot.define do
  factory :account do
    branch { '0123' }
    account_number { '12345' }
    limit { rand(1000.0..1800.0).round(2) }
    last_limit_update { Time.zone.now }
    balance { 0.0 }
    user { create(:user) }

    trait :another_account do
      branch { '4567' }
      account_number { '67890' }
      limit { rand(1000.0..1800.0).round(2) }
      last_limit_update { Time.zone.now }
      balance { 500.0 }
      user { create(:user, :another_user) }
    end
  end
end
