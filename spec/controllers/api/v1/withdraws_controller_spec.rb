require 'rails_helper'

RSpec.describe Api::V1::WithdrawsController, type: :controller do
  describe 'POST /api/v1/accounts/withdraw_request' do
    context 'quando é uma transação válida' do
      it 'retorna status code 201' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_params = { amount: 250.0 }
        token = account.user.token

        withdraw_request(token, withdraw_params)

        expect(response.status).to eq(201)
      end

      it 'renderiza mensagem com os valores da transação' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_params = { amount: 250.0 }
        token = account.user.token

        withdraw_request(token, withdraw_params)

        message = 'Responda "1" para a opção 1 e "2" para a opção 2'
        possibilities = [
          '5 nota(s) de 50',
          '4 nota(s) de 50, 2 nota(s) de 20, 5 nota(s) de 2'
        ]

        expect(JSON.parse(response.body)['message']).to eq(message)
        expect(JSON.parse(response.body)['amount']).to eq(250.0)
        expect(JSON.parse(response.body)['cash_possibilities']).to eq(possibilities)
      end
    end

    context 'quando é uma transação inválida' do
      it 'retorna status code 403' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_params = { amount: 231.0 }
        token = account.user.token

        withdraw_request(token, withdraw_params)

        expect(response.status).to eq(403)
      end

      it 'renderiza mensagem de erro' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_params = { amount: 231.0 }
        token = account.user.token

        withdraw_request(token, withdraw_params)

        message = 'Requisição de saque não autorizada!'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end
  end

  describe 'POST /api/v1/accounts/withdraw_confirm' do
    context 'quando o usuário informa uma requisição válida' do
      context 'quando o usuário da requisição é o mesmo da confirmação' do
        it 'retorna status code 201' do
          account = create(:account, limit: 1500.0, balance: 1500.0)
          withdraw_request = create(
            :account_withdraw_request, account: account, amount: 250.0
          )
          token = account.user.token

          withdraw_confirm_params = {
            account_withdraw_request_id: withdraw_request.id,
            possibility: 2
          }

          withdraw_confirm_request(token, withdraw_confirm_params)

          expect(response.status).to eq(201)
        end

        it 'renderiza mensagem com os valores da transação' do
          account = create(:account, limit: 1500.0, balance: 1500.0)
          withdraw_request = create(
            :account_withdraw_request, account: account, amount: 250.0
          )
          token = account.user.token

          withdraw_confirm_params = {
            account_withdraw_request_id: withdraw_request.id,
            possibility: 2
          }

          withdraw_confirm_request(token, withdraw_confirm_params)

          message = 'Saque realizado com sucesso!'

          expect(JSON.parse(response.body)['message']).to eq(message)
          expect(JSON.parse(response.body)['amount']).to eq(250.0)
          expect(JSON.parse(response.body)['balance']).to eq(1250.0)
        end
      end
    end

    context 'quando a requisição não é encontrada' do
      it 'retorna status code 404' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_request = create(
          :account_withdraw_request, account: account, amount: 250.0
        )
        token = account.user.token

        withdraw_confirm_params = {
          account_withdraw_request_id: withdraw_request.id + 1,
          possibility: 2
        }

        withdraw_confirm_request(token, withdraw_confirm_params)

        expect(response.status).to eq(404)
      end

      it 'renderiza mensagem de erro' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_request = create(
          :account_withdraw_request, account: account, amount: 250.0
        )
        token = account.user.token

        withdraw_confirm_params = {
          account_withdraw_request_id: withdraw_request.id + 1,
          possibility: 2
        }

        withdraw_confirm_request(token, withdraw_confirm_params)

        message = 'Requisição de saque não encontrada!'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end

    context 'quando o usuário da requisição é diferente da confirmação' do
      it 'retorna status code 403' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_request = create(
          :account_withdraw_request, account: account, amount: 250.0
        )
        token = 'WrONgToKEn'

        withdraw_confirm_params = {
          account_withdraw_request_id: withdraw_request.id,
          possibility: 2
        }

        withdraw_confirm_request(token, withdraw_confirm_params)

        expect(response.status).to eq(403)
      end

      it 'renderiza mensagem de erro' do
        account = create(:account, limit: 1500.0, balance: 1500.0)
        withdraw_request = create(
          :account_withdraw_request, account: account, amount: 250.0
        )
        token = 'WrONgToKEn'

        withdraw_confirm_params = {
          account_withdraw_request_id: withdraw_request.id,
          possibility: 2
        }

        withdraw_confirm_request(token, withdraw_confirm_params)

        message = 'Saque não autorizado!'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end
  end

  def withdraw_request(token, withdraw_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = token

    post :withdraw,
         params: withdraw_params
  end

  def withdraw_confirm_request(token, withdraw_confirm_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = token

    post :confirm,
         params: withdraw_confirm_params
  end
end
