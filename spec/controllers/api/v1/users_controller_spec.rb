require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST /api/v1/users' do
    context 'quando usuário informa os dados corretamente' do
      it 'retorna status code 201' do
        user_params = {
          full_name: 'Fausto Silva', document: '12345678910',
          address: 'Rua da Minha Casa, 1000', birthday: '02/05/1950', gender: 'M',
          password: 'olocomeu'
        }

        create_user_request(user_params)

        expect(response.status).to eq(201)
      end

      it 'renderiza mensagem com os dados da conta' do
        user_params = {
          full_name: 'Fausto Silva', document: '12345678910',
          address: 'Rua da Minha Casa, 1000', birthday: '02/05/1950', gender: 'M',
          password: 'olocomeu'
        }

        create_user_request(user_params)

        expect(JSON.parse(response.body)['branch']).not_to be_nil
        expect(JSON.parse(response.body)['account_number']).not_to be_nil
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context 'quando usuário informa dados de forma incorreta' do
      it 'retorna status code 422' do
        user_params = {
          full_name: 'Fausto Silva', document: '123', address: '', birthday: '',
          gender: 'M', password: 'errou'
        }

        create_user_request(user_params)

        expect(response.status).to eq(422)
      end

      it 'renderiza mensagem de erro' do
        user_params = {
          full_name: 'Fausto Silva', document: '123', address: '', birthday: '',
          gender: 'M', password: 'errou'
        }

        create_user_request(user_params)

        message = 'Document is the wrong length (should be 11 characters), ' \
          'Address can\'t be blank, Birthday can\'t be blank, Password is ' \
          'the wrong length (should be 8 characters)'

        expect(JSON.parse(response.body)['message']).to eq(message)
      end
    end
  end

  def create_user_request(user_params)
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'

    post :create,
         params: user_params
  end
end
