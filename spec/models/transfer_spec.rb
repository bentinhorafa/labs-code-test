require 'rails_helper'

RSpec.describe Transfer, type: :model do
  subject { create(:transfer) }

  describe 'validations' do
    describe 'association' do
      it { is_expected.to belong_to(:origin) }
      it { is_expected.to belong_to(:destiny) }
      it { is_expected.to have_many(:account_transactions) }
    end

    describe 'presence' do
      it { is_expected.to validate_presence_of(:amount) }
    end

    describe 'numericality' do
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0.0) }
    end
  end
end
