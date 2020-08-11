require 'rails_helper'

RSpec.describe AccountCreateService do
  let(:user) { create(:user) }

  describe '#create' do
    let(:account) { described_class.create(user) }

    it 'cria uma conta viculada ao usuário informado' do
      expect(account).to be_persisted
      expect(account.branch.length).to eq(4)
      expect(account.account_number.length).to eq(5)
      expect(account.limit).to be_between(1000.0, 1800.0)
      expect(account.balance).to be_zero
    end
  end
end
