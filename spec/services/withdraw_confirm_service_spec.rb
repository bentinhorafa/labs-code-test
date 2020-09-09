require 'rails_helper'

RSpec.describe WithdrawConfirmService do
  describe '#confirm' do
    context 'quando o usuário da requisição é igual ao da confirmação' do
      context 'quando a opção de saque é informada' do
        it 'cria uma account_transaction de saque' do
          account = create(:account, limit: 1500.0, balance: 1500.0)
          user = account.user

          withdraw_params = { token: user.token, amount: 250.0 }
          account_withdraw_request = AccountWithdrawService.new(**withdraw_params).withdraw

          withdraw_transaction = described_class.new(
            token: user.token,
            account_withdraw_request: account_withdraw_request,
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

    context 'quando o usuário da requisição é DIFERENTE ao da confirmação' do
      it 'NÃO cria uma account_transaction de saque' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        user = account.user

        withdraw_params = { token: user.token, amount: 250.0 }
        account_withdraw_request = AccountWithdrawService.new(**withdraw_params).withdraw

        expect do
          described_class.new(
            token: 'tHIsISaNotHErTokEN',
            account_withdraw_request: account_withdraw_request,
            possibility: 1
          ).confirm
        end.not_to change { AccountTransaction.all.count }
      end
    end
  end

  describe '.confirm' do
    it 'inicia o serviço, executa e retorna o resultado de #confirm' do
      service = instance_double('WithdrawConfirmService')
      account_withdraw_request = instance_double('AccountWithdrawRequest')
      account_transaction = instance_double('AccountTransaction')
      confirm_params = {
        token: 'DuMMytOkeN',
        account_withdraw_request: account_withdraw_request,
        possibility: 1
      }

      expect(described_class).to receive(:new).with(confirm_params).once.and_return(service)
      expect(service).to receive(:confirm).and_return(account_transaction)
      expect(described_class.confirm(confirm_params)).to eq(account_transaction)
    end
  end
end
