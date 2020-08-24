require 'rails_helper'

RSpec.describe AccountWithdrawService do
  subject do
    described_class.new(withdraw_params)
  end

  let(:account) { create(:account, limit: 1500.0, balance: 1500.0) }
  let(:user) { account.user }

  let(:withdraw_params) do
    {
      token: user.token,
      amount: 250.0
    }
  end

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
            subject.withdraw

            withdraw_request = AccountWithdrawRequest.last

            expect(withdraw_request).to be_persisted
          end

          it 'retorna mensagem com o id e as possibilidades de saque' do
            response = subject.withdraw
            possibilities_array = [
              '5 nota(s) de 50',
              '4 nota(s) de 50, 2 nota(s) de 20, 5 nota(s) de 2'
            ]

            withdraw_request = AccountWithdrawRequest.last
            success_message = success_message(
              withdraw_request: withdraw_request,
              possibilities_array: possibilities_array
            )

            expect(response).to eq(success_message)
          end
        end
      end
    end
  end

  describe '.withdraw' do
    it 'inicia o serviço, executa e retorna o resultado de #call' do
      service = instance_double('AccountWithdrawService')
      hash = instance_double(Hash)

      expect(described_class).to receive(:new).with(withdraw_params).once.and_return(service)
      expect(service).to receive(:withdraw).and_return(hash)

      expect(described_class.withdraw(withdraw_params)).to eq(hash)
    end
  end

  def success_message(withdraw_request:, amount: 250.0, possibilities_array:)
    {
      id: withdraw_request.id,
      amount: amount,
      cash_possibilities: possibilities_array
    }
  end
end
