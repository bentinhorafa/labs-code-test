require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  describe 'PUT /api/v1/accounts/:token/update_limit' do
    context 'quando última atualização de limite ocorreu há mais de 10 minutos' do
      it 'retorna status code 202' do
        past_time = Time.zone.now - 600
        account = create(:account, last_limit_update: past_time)
        update_limit_params = { token: account.user.token, limit: 2500.0 }

        update_limit_request(update_limit_params)

        expect(response.status).to eq(202)
      end

      it 'renderiza mensagem com os dados da conta' do
        past_time = Time.zone.now - 600
        account = create(:account, last_limit_update: past_time)
        update_limit_params = { token: account.user.token, limit: 2500.0 }

        update_limit_request(update_limit_params)

        message = 'Limite atualizado com sucesso!'

        expect(JSON.parse(response.body)['message']).to eq(message)
        expect(JSON.parse(response.body)['limit']).to eq(2500.0)
      end
    end

    context 'quando última atualização de limite ocorreu há menos de 10 minutos' do
      it 'retorna status code 403' do
        past_time = Time.zone.now - 500
        account = create(:account, last_limit_update: past_time)
        update_limit_params = { token: account.user.token, limit: 2500.0 }

        update_limit_request(update_limit_params)

        expect(response.status).to eq(403)
      end

      it 'renderiza mensagem de erro' do
        past_time = Time.zone.now - 500
        account = create(:account, last_limit_update: past_time)
        update_limit_params = { token: account.user.token, limit: 2500.0 }

        update_limit_request(update_limit_params)

        message = 'Não autorizado!'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end
  end

  def update_limit_request(update_limit_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'

    put :update,
        params: update_limit_params
  end
end
