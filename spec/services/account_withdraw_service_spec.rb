require 'rails_helper'

RSpec.describe AccountWithdrawService do
  describe '#withdraw' do
    context 'quando o valor é maior ou igual a 20' do
      context 'quando o valor é par' do
        context 'quando o usuário possui o valor em conta' do
          # PENDING
          # headers: {
          #   'Content-Type' => 'application/json',
          #   'Accept' => 'application/json',
          #   'Authorization' => user.token
          # }
          it 'cria uma requisição de saque' do
            account = create(:account, limit: 1500.0, balance: 1500.0)
            user = account.user
            withdraw_params = { token: user.token, amount: 250.0 }

            withdraw_request = described_class.new(**withdraw_params).withdraw

            expect(withdraw_request).to be_persisted
            expect(withdraw_request.account).to eq(account)
          end

          it 'salva as possibilidades de saque' do
            account = create(:account, limit: 1500.0, balance: 1500.0)
            user = account.user
            withdraw_params = { token: user.token, amount: 250.0 }

            possibilities_string = '5x50|4x50-2x20-5x2'

            withdraw_request = described_class.new(**withdraw_params).withdraw

            expect(withdraw_request.cash_possibilities).to eq(possibilities_string)
          end
        end
      end
    end
  end

  describe '.withdraw' do
    it 'inicia o serviço, executa e retorna o resultado de #withdraw' do
      account = create(:account, limit: 1500.0, balance: 1500.0)
      user = account.user
      withdraw_params = { token: user.token, amount: 250.0 }

      service = instance_double('AccountWithdrawService')
      account_withdraw_request = instance_double('AccountWithdrawRequest')

      expect(described_class).to receive(:new).with(withdraw_params).once.and_return(service)
      expect(service).to receive(:withdraw).and_return(account_withdraw_request)

      expect(described_class.withdraw(withdraw_params)).to eq(account_withdraw_request)
    end
  end
end
