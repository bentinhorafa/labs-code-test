require 'rails_helper'

RSpec.describe AccountDepositService do
  describe '#deposit' do
    context 'quando limite da conta não será ultrapassado' do
      context 'quando limite diário de R$ 800,00 não será ultrapassado' do
        it 'cria transação de depósito para a conta do usuário' do
          account = create(:account, limit: 1500.0, balance: 500.0)
          deposit_params = { token: account.user.token, amount: 300.0 }

          deposit_transaction = described_class.new(**deposit_params).deposit

          expect(deposit_transaction.transaction_type).to eq('deposit')
        end

        it 'atualiza saldo da conta do usuário' do
          account = create(:account, limit: 1500.0, balance: 500.0)
          deposit_params = { token: account.user.token, amount: 300.0 }
          balance = account.balance

          described_class.new(**deposit_params).deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end

      context 'quando valor informado é negativo' do
        it 'atualiza saldo da conta do usuário SOMANDO valor' do
          account = create(:account, limit: 1500.0, balance: 500.0)
          deposit_params = { token: account.user.token, amount: -300.0 }
          balance = account.balance

          described_class.new(**deposit_params).deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end

      context 'quando valor informado possui centavos' do
        it 'atualiza saldo da conta do usuário SOMANDO valor arredondado' do
          account = create(:account, limit: 1500.0, balance: 500.0)
          deposit_params = { token: account.user.token, amount: -300.31 }
          balance = account.balance

          described_class.new(**deposit_params).deposit

          expect(account.reload.balance).to eq(balance + 300.0)
        end
      end
    end

    context 'quando limite da conta é ultrapassado' do
      it 'não cria transação de depósito para a conta do usuário' do
        account = create(:account, limit: 1500.0, balance: 1201.0)
        deposit_params = { token: account.user.token, amount: 300.0 }

        debit_transaction = described_class.new(**deposit_params).deposit

        expect(debit_transaction).to be_nil
      end
    end

    context 'quando limite diário de depósitos é ultrapassado' do
      it 'não cria transação de depósito para a conta do usuário' do
        account = create(:account, limit: 1600.0, balance: 500.0)
        deposit_params = { token: account.user.token, amount: 300.0 }

        create(:account_transaction, account: account, amount: 400.0)

        last_account_transaction = create(
          :account_transaction, account: account, amount: 200.0
        )

        debit_transaction = described_class.new(**deposit_params).deposit
        last_transaction = account.account_transactions.deposit.last

        expect(debit_transaction).to be_nil
        expect(last_transaction).to eq(last_account_transaction)
      end
    end
  end

  describe '.deposit' do
    it 'inicia o serviço, executa e retorna o resultado de #deposit' do
      service = instance_double('AccountDepositService')
      account = instance_double('Account')
      deposit_params = { token: 'DuMMytOkeN', amount: 300.0 }

      expect(described_class).to receive(:new).with(deposit_params).once.and_return(service)
      expect(service).to receive(:deposit).and_return(account)

      expect(described_class.deposit(deposit_params)).to eq(account)
    end
  end
end
