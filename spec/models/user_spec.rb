require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    describe 'association' do
      it { is_expected.to have_one(:account) }
    end

    describe 'presence' do
      it { is_expected.to validate_presence_of(:full_name) }
      it { is_expected.to validate_presence_of(:document) }
      it { is_expected.to validate_presence_of(:address) }
      it { is_expected.to validate_presence_of(:birthday) }
      it { is_expected.to validate_presence_of(:gender) }
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_presence_of(:token) }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:document).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:token) }
    end

    describe 'length' do
      it { is_expected.to validate_length_of(:full_name).is_at_most(200) }
      it { is_expected.to validate_length_of(:document).is_equal_to(11) }
      it { is_expected.to validate_length_of(:address).is_at_most(200) }
      it { is_expected.to validate_length_of(:gender).is_equal_to(1) }
      it { is_expected.to validate_length_of(:password).is_equal_to(8) }
    end
  end
end
