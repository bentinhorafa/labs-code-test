require 'rails_helper'

RSpec.describe AccountTransferService do
  describe '#transfer' do
    context 'quando as duas contas são encontradas' do
      context 'quando o saldo da conta de origem permite a transferência' do
        context 'quando o limite da conta de destino permite a transferência' do
          it 'cria uma account_transaction de débito para o origem' do
            origin_account = create(:account, limit: 1500.0, balance: 1500.0)
            destiny_account =
              create(:account, :another_account, limit: 1200.0, balance: 600.0)

            transfer_params = {
              token: origin_account.user.token,
              destiny_branch: destiny_account.branch,
              destiny_account_number: destiny_account.account_number,
              amount: 500
            }

            expect do
              described_class.new(**transfer_params).transfer
            end.to change { AccountTransaction.all.count }.by(2)

            expect(origin_account.account_transactions.last.amount).to eq(-500)
          end

          it 'cria uma account_transaction de crédito para o destino' do
            origin_account = create(:account, limit: 1500.0, balance: 1500.0)
            destiny_account =
              create(:account, :another_account, limit: 1200.0, balance: 600.0)

            transfer_params = {
              token: origin_account.user.token,
              destiny_branch: destiny_account.branch,
              destiny_account_number: destiny_account.account_number,
              amount: 500
            }

            expect do
              described_class.new(**transfer_params).transfer
            end.to change { AccountTransaction.all.count }.by(2)

            expect(destiny_account.account_transactions.last.amount).to eq(500)
          end

          it 'atualiza o saldo das duas contas' do
            origin_account = create(:account, limit: 1500.0, balance: 1500.0)
            destiny_account =
              create(:account, :another_account, limit: 1200.0, balance: 600.0)

            transfer_params = {
              token: origin_account.user.token,
              destiny_branch: destiny_account.branch,
              destiny_account_number: destiny_account.account_number,
              amount: 500
            }

            described_class.new(**transfer_params).transfer

            expect(origin_account.reload.balance).to eq(1000.0)
            expect(destiny_account.reload.balance).to eq(1100.0)
          end
        end
      end
    end

    context 'quando a conta de destino não é encontrada' do
      it 'não cria nenhuma account_transaction' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)

        transfer_params = {
          token: origin_account.user.token,
          destiny_branch: '9999',
          destiny_account_number: '99999',
          amount: 500
        }

        expect do
          described_class.new(**transfer_params).transfer
        end.not_to change { AccountTransaction.all.count }
      end
    end

    context 'quando o saldo da conta de origem NÃO permite a transferência' do
      it 'não cria nenhuma account_transaction' do
        origin_account = create(:account, limit: 1500.0, balance: 400.0)
        destiny_account =
          create(:account, :another_account, limit: 1200.0, balance: 600.0)

        transfer_params = {
          token: origin_account.user.token,
          destiny_branch: destiny_account.branch,
          destiny_account_number: destiny_account.account_number,
          amount: 500
        }

        expect do
          described_class.new(**transfer_params).transfer
        end.not_to change { AccountTransaction.all.count }
      end
    end

    context 'quando o limite da conta de destino NÃO permite a transferência' do
      it 'não cria nenhuma account_transaction' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)
        destiny_account =
          create(:account, :another_account, limit: 1000.0, balance: 600.0)

        transfer_params = {
          token: origin_account.user.token,
          destiny_branch: destiny_account.branch,
          destiny_account_number: destiny_account.account_number,
          amount: 500
        }

        expect do
          described_class.new(**transfer_params).transfer
        end.not_to change { AccountTransaction.all.count }
      end
    end
  end

  describe '.transfer' do
    it 'inicia o serviço, executa e retorna o resultado de #transfer' do
      transfer_params = {
        token: 'DuMMytOkeN',
        destiny_branch: '0123',
        destiny_account_number: '45678',
        amount: 500
      }

      service = instance_double('AccountTransferService')
      account_transaction = instance_double('AccountTransaction')

      expect(described_class).to receive(:new).with(transfer_params).once.and_return(service)
      expect(service).to receive(:transfer).and_return(account_transaction)
      expect(described_class.transfer(transfer_params)).to eq(account_transaction)
    end
  end
end
