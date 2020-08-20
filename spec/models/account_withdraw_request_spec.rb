require 'rails_helper'

RSpec.describe AccountWithdrawRequest, type: :model do
  subject { create(:account_withdraw_request) }

  describe 'validations' do
    describe 'association' do
      it { is_expected.to belong_to(:account) }
      it { is_expected.to belong_to(:account_transaction).optional }
    end

    describe 'presence' do
      it { is_expected.to validate_presence_of(:amount) }
    end

    describe 'numericality' do
      it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(2.0) }
      it { is_expected.to validate_numericality_of(:amount).even }
    end
  end
end
