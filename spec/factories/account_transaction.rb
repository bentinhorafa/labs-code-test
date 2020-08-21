FactoryBot.define do
  factory :account_transaction do
    account { create(:account) }
    transaction_type { 1 }
    amount { 500.0 }

    trait :withdraw do
      transaction_type { 0 }
    end

    trait :deposit do
      transaction_type { 1 }
    end

    trait :transfer do
      transaction_type { 2 }
    end
  end
end
