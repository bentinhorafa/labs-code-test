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

  describe 'POST /api/v1/accounts/deposit' do
    context 'quando é uma transação válida' do
      it 'retorna status code 201' do
        account = create(:account, limit: 1500.0, balance: 500.0)
        deposit_params = { amount: 300.0 }
        token = account.user.token

        deposit_request(token, deposit_params)

        expect(response.status).to eq(201)
      end

      it 'renderiza mensagem com os valores da transação' do
        account = create(:account, limit: 1500.0, balance: 500.0)
        deposit_params = { amount: 300.0 }
        token = account.user.token

        deposit_request(token, deposit_params)

        message = 'Depósito realizado com sucesso!'

        expect(JSON.parse(response.body)['message']).to eq(message)
        expect(JSON.parse(response.body)['amount']).to eq(300.0)
        expect(JSON.parse(response.body)['balance']).to eq(800.0)
      end
    end

    context 'quando é uma transação inválida' do
      it 'retorna status code 403' do
        account = create(:account, limit: 1500.0, balance: 1201.0)
        deposit_params = { amount: 300.0 }
        token = account.user.token

        deposit_request(token, deposit_params)

        expect(response.status).to eq(403)
      end

      it 'renderiza mensagem de erro' do
        account = create(:account, limit: 1500.0, balance: 1201.0)
        deposit_params = { amount: 300.0 }
        token = account.user.token

        deposit_request(token, deposit_params)

        message = 'Depósito não autorizado!'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end
  end

  describe 'POST /api/v1/accounts/transfer' do
    context 'quando é uma transação válida' do
      it 'retorna status code 201' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)
        destiny_account =
          create(:account, :another_account, limit: 1200.0, balance: 600.0)
        token = origin_account.user.token

        transfer_params = {
          destiny_branch: destiny_account.branch,
          destiny_account_number: destiny_account.account_number,
          amount: 500.0
        }

        transfer_request(token, transfer_params)

        expect(response.status).to eq(201)
      end

      it 'renderiza mensagem com os valores da transação' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)
        destiny_account =
          create(:account, :another_account, limit: 1200.0, balance: 600.0)
        token = origin_account.user.token

        transfer_params = {
          destiny_branch: destiny_account.branch,
          destiny_account_number: destiny_account.account_number,
          amount: 500.0
        }

        transfer_request(token, transfer_params)

        message = 'Transferência realizada com sucesso!'

        expect(JSON.parse(response.body)['message']).to eq(message)
        expect(JSON.parse(response.body)['amount']).to eq(500.0)
        expect(JSON.parse(response.body)['balance']).to eq(1000.0)
        expect(JSON.parse(response.body)['transfer_to']).to eq(destiny_account.user.full_name)
      end
    end

    context 'quando é uma transação inválida' do
      it 'retorna status code 403' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)
        token = origin_account.user.token

        transfer_params = {
          destiny_branch: '9999',
          destiny_account_number: '99999',
          amount: 500.0
        }

        transfer_request(token, transfer_params)

        expect(response.status).to eq(403)
      end

      it 'renderiza mensagem de erro' do
        origin_account = create(:account, limit: 1500.0, balance: 1500.0)
        token = origin_account.user.token

        transfer_params = {
          destiny_branch: '9999',
          destiny_account_number: '99999',
          amount: 500.0
        }

        transfer_request(token, transfer_params)

        message = 'Transferência não autorizada!'

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

  def deposit_request(token, deposit_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = token

    post :deposit,
         params: deposit_params
  end

  def transfer_request(token, transfer_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = token

    post :transfer,
         params: transfer_params
  end
end
