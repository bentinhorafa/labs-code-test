require 'rails_helper'

RSpec.describe AccountDepositService do
  subject do
    described_class.new(deposit_params)
  end

  let(:deposit_params) do
    {
      token: 'mYauTOGeneRaTeDDuMMyToKen',
      amount: 300.0
    }
  end

  let(:account) { create(:account) }

  describe '#deposit' do
    context 'quando limite da conta não será ultrapassado' do
      context 'quando limite diário de R$ 800,00 não será ultrapassado' do
        before do
          account.update(limit: 1500.0, balance: 500.0)
        end

        it 'cria transação de depósito para a conta do usuário' do
          subject.deposit

          last_transaction = account.account_transactions.deposit.last

          expect(last_transaction.transaction_type).to eq('deposit')
        end

        it 'atualiza saldo da conta do usuário' do
          balance = account.balance

          subject.deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end

      context 'quando valor informado é negativo' do
        let(:deposit_params) do
          {
            token: 'mYauTOGeneRaTeDDuMMyToKen',
            amount: -300.0
          }
        end

        it 'atualiza saldo da conta do usuário SOMANDO valor' do
          balance = account.balance

          subject.deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end

      context 'quando valor informado possui centavos' do
        let(:deposit_params) do
          {
            token: 'mYauTOGeneRaTeDDuMMyToKen',
            amount: -300.31
          }
        end

        it 'atualiza saldo da conta do usuário SOMANDO valor arredondado' do
          balance = account.balance

          subject.deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end
    end

    context 'quando limite da conta é ultrapassado' do
      before do
        account.update(limit: 1500.0, balance: 1201.0)
      end

      it 'não cria transação de depósito para a conta do usuário' do
        subject.deposit

        last_transaction = account.account_transactions.deposit.last

        expect(last_transaction).to eq(nil)
      end
    end

    context 'quando limite diário de depósitos é ultrapassado' do
      before do
        account.update(limit: 1600.0, balance: 500.0)
      end

      it 'não cria transação de depósito para a conta do usuário' do
        create(:account_transaction, account: account, amount: 400.0)
        last_account_transaction = create(
          :account_transaction, account: account, amount: 200.0
        )

        subject.deposit

        last_transaction = account.account_transactions.deposit.last

        expect(last_transaction).to eq(last_account_transaction)
      end
    end
  end

  describe '.deposit' do
    it 'inicia o serviço, executa e retorna o resultado de #deposit' do
      service = instance_double('AccountDepositService')
      account = instance_double('Account')

      expect(described_class).to receive(:new).with(deposit_params).once.and_return(service)
      expect(service).to receive(:deposit).and_return(account)

      expect(described_class.deposit(deposit_params)).to eq(account)
    end
  end
end