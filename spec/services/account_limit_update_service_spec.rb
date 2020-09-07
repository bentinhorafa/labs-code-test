require 'rails_helper'

RSpec.describe AccountLimitUpdateService do
  describe '#update' do
    context 'quando passou 10 minutos ou mais desde a última atualização' do
      context 'quando o valor em conta é menor ou igual ao limite escolhido' do
        it 'altera valor do limite' do
          past_time = Time.zone.now - 600
          account = create(:account, last_limit_update: past_time)
          update_limit_params = { token: account.user.token, limit: 2500.0 }

          described_class.new(**update_limit_params).update

          expect(account.reload.limit).to eq(2500.0)
        end

        it 'altera última data de atualização' do
          past_time = Time.zone.now - 600
          account = create(:account, last_limit_update: past_time)
          update_limit_params = { token: account.user.token, limit: 2500.0 }

          expect do
            described_class.new(**update_limit_params).update
          end.to change { account.reload.last_limit_update }
        end
      end

      context 'quando o valor em conta é maior que o limite escolhido' do
        it 'não altera valor do limite' do
          past_time = Time.zone.now - 600
          account = create(:account, balance: 2700.0, last_limit_update: past_time)
          update_limit_params = { token: account.user.token, limit: 2500.0 }

          expect do
            described_class.new(**update_limit_params).update
          end.not_to change { account.reload.limit }
        end
      end
    end

    context 'quando passou menos de 10 minutos desde a última atualização' do
      it 'não altera valor do limite' do
        past_time = Time.zone.now - 500
        account = create(:account, last_limit_update: past_time)
        update_limit_params = { token: account.user.token, limit: 2500.0 }

        expect do
          described_class.new(**update_limit_params).update
        end.not_to change { account.reload.limit }
      end
    end
  end

  describe '.update' do
    it 'inicia o serviço, executa e retorna o resultado de #update' do
      service = instance_double('AccountLimitUpdateService')
      account = instance_double('Account')
      update_limit_params = { token: 'DuMMytOkeN', limit: 2500.0 }

      expect(described_class).to receive(:new).with(update_limit_params).once.and_return(service)
      expect(service).to receive(:update).and_return(account)

      expect(described_class.update(update_limit_params)).to eq(account)
    end
  end
end
