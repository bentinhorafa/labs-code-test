require 'rails_helper'

RSpec.describe UserCreateService do
  describe '#create' do
    it 'cria um usuário com os dados informados' do
      user_params = {
        full_name: 'Fausto Silva', document: '12345678910',
        address: 'Rua da Minha Casa, 1000', birthday: '02/05/1950', gender: 'M',
        password: 'olocomeu'
      }

      user = described_class.new(**user_params).create

      expect(user).to be_persisted
      expect(user.full_name).to eq('Fausto Silva')
      expect(user.document).to eq('12345678910')
      expect(user.address).to eq('Rua da Minha Casa, 1000')
      expect(user.birthday.to_s).to eq('1950-05-02')
      expect(user.gender).to eq('M')
      expect(user.account).to be_persisted
    end

    it 'gera um token usando o SecureRandom' do
      allow(SecureRandom).to receive(:hex).and_return('DuMMyToKeN')

      user_params = {
        full_name: 'Fausto Silva', document: '12345678910',
        address: 'Rua da Minha Casa, 1000', birthday: '02/05/1950', gender: 'M',
        password: 'olocomeu'
      }

      user = described_class.new(**user_params).create

      expect(user.token).to eq('DuMMyToKeN')
    end

    context 'quando há campos obrigatórios não preenchidos ou mínimo de dígitos não atendido' do
      it 'não cria conta e retorna usuário não persistido e seus respectivos erros' do
        user_params = {
          full_name: 'Fausto Silva', document: '123', address: '', birthday: '',
          gender: 'M', password: 'errou'
        }

        user = described_class.new(**user_params).create

        expect(user.account).to be_nil
        expect(user).not_to be_persisted
        expect(user.errors.full_messages).to include('Document is the wrong' \
          ' length (should be 11 characters)')
        expect(user.errors.full_messages).to include('Address can\'t be blank')
        expect(user.errors.full_messages).to include('Birthday can\'t be blank')
        expect(user.errors.full_messages).to include('Password is the wrong' \
          ' length (should be 8 characters)')
      end
    end
  end

  describe '.create' do
    it 'inicia o serviço, invoca e retorna o resultado de #create' do
      service = instance_double('UserCreateService')
      user = instance_double('User')
      user_params = {
        full_name: 'Fausto Silva', document: '12345678910',
        address: 'Rua da Minha Casa, 1000', birthday: '02/05/1950', gender: 'M',
        password: 'olocomeu'
      }

      expect(described_class).to receive(:new).with(user_params).once.and_return(service)
      expect(service).to receive(:create).and_return(user)

      expect(described_class.create(user_params)).to eq(user)
    end
  end
end
