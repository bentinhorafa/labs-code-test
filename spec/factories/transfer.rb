FactoryBot.define do
  factory :transfer do
    origin { create(:account, :another_account) }
    destiny { create(:account) }
    amount { 200.0 }
  end
end
