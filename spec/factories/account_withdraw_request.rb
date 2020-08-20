FactoryBot.define do
  factory :account_withdraw_request do
    amount { 100.0 }
    cash_possibility { '2|50' }
    account { create(:account) }
  end
end
