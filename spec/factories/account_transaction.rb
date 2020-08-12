FactoryBot.define do
  factory :account_transaction do
    account { create(:account) }
    type { 1 }
    amount { 500.0 }
  end
end
