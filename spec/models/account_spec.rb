require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { create(:account) }

  describe 'validations' do
    describe 'association' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to have_many(:account_transactions) }
    end

    describe 'presence' do
      it { is_expected.to validate_presence_of(:branch) }
      it { is_expected.to validate_presence_of(:account_number) }
      it { is_expected.to validate_presence_of(:limit) }
      it { is_expected.to validate_presence_of(:last_limit_update) }
    end

    describe 'uniqueness' do
      it do
        expect(subject).to validate_uniqueness_of(:account_number)
          .scoped_to(:branch).case_insensitive
      end
    end

    describe 'length' do
      it { is_expected.to validate_length_of(:branch).is_equal_to(4) }
      it { is_expected.to validate_length_of(:account_number).is_equal_to(5) }
    end

    describe 'numericality' do
      it { is_expected.to validate_numericality_of(:branch).only_integer }
      it { is_expected.to validate_numericality_of(:account_number).only_integer }
      it { is_expected.to validate_numericality_of(:limit).is_greater_than_or_equal_to(0.0) }
      it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0.0) }
    end
  end
end
