require 'rails_helper'

RSpec.describe WithdrawConfirmService do
  describe '#confirm' do
    context 'quando o id é encontrado' do
      context 'quando a opção de saque é informada' do
        it 'cria uma account_transaction de saque' do
          account = create(:account, limit: 1500.0, balance: 1500.0)
          user = account.user

          withdraw_params = { token: user.token, amount: 250.0 }
          account_withdraw_request = AccountWithdrawService.new(**withdraw_params).withdraw

          withdraw_transaction = described_class.new(
            account_withdraw_request_id: account_withdraw_request.id,
            possibility: 1
          ).confirm

          expect(withdraw_transaction).to be_persisted
          expect(withdraw_transaction.account).to eq(account)
          expect(withdraw_transaction.account.user).to eq(user)

          expect(withdraw_transaction.account_withdraw_request)
            .to eq(account_withdraw_request)
        end
      end
    end

    context 'quando o id NÃO é encontrado' do
      it 'exibe mensagem de erro de transação não encontrada' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        user = account.user

        withdraw_params = { token: user.token, amount: 250.0 }
        account_withdraw_request = AccountWithdrawService.new(**withdraw_params).withdraw

        expect do
          described_class.new(
            account_withdraw_request_id: account_withdraw_request.id - 1,
            possibility: 1
          ).confirm
        end.to raise_error(
          WithdrawConfirmService::WithdrawRequestIdNotFound,
          "Withdraw Request ##{account_withdraw_request.id - 1} not found!"
        )
      end
    end
  end

  describe '.confirm' do
    it 'inicia o serviço, executa e retorna o resultado de #confirm' do
      confirm_params = { account_withdraw_request_id: 3, possibility: 1 }

      service = instance_double('WithdrawConfirmService')
      account_transaction = instance_double('AccountTransaction')

      expect(described_class).to receive(:new).with(confirm_params).once.and_return(service)
      expect(service).to receive(:confirm).and_return(account_transaction)
      expect(described_class.confirm(confirm_params)).to eq(account_transaction)
    end
  end
end
