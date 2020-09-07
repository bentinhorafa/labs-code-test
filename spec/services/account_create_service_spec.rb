require 'rails_helper'

RSpec.describe AccountCreateService do
  describe '#create' do
    it 'cria uma conta viculada ao usuário informado' do
      user = create(:user)
      account = described_class.create(user)

      expect(account).to be_persisted
      expect(account.branch.length).to eq(4)
      expect(account.account_number.length).to eq(5)
      expect(account.limit).to be_between(1000.0, 1800.0)
      expect(account.balance).to be_zero
    end
  end
end
