require 'rails_helper'

RSpec.describe AccountStatementService do
  describe '#statement' do
    context 'quando a quantidade de dias NÃO é informada' do
      it 'retorna as transações dos últimos 7 dias' do
        account = create(:account, limit: 1000.0, balance: 1800.0)

        create_list(
          :account_transaction, 2, :withdraw,
          account: account, amount: 80.0, created_at: (Time.zone.today - 7.days)
        )

        create_list(
          :account_transaction, 3, :withdraw, account: account, amount: 100.0
        )

        create_list(
          :account_transaction, 3, :deposit, account: account, amount: 200.0
        )

        statement_first_day = (Time.zone.today - 6.days).beginning_of_day
        statement = described_class.new(token: account.user.token).statement

        expect(statement.first.created_at).to be >= statement_first_day
        expect(statement.last.created_at).to be <= Time.zone.today.end_of_day
      end
    end

    context 'quando a quantidade de dias é informada' do
      context 'quando a quantidade de dias é menor ou igual a 90' do
        it 'retorna as transações dos últimos x dias informados' do
          account = create(:account, limit: 1000.0, balance: 1800.0)
          days = 30

          create_list(
            :account_transaction, 2, :withdraw,
            account: account, amount: 80.0, created_at: (Time.zone.today - days.days)
          )

          create_list(
            :account_transaction, 3, :withdraw,
            account: account, amount: 100.0, created_at: (Time.zone.today - 18.days)
          )

          create_list(
            :account_transaction, 3, :deposit, account: account, amount: 200.0
          )

          statement_first_day = (Time.zone.today - (days - 1).days).beginning_of_day
          statement = described_class.new(token: account.user.token, days: days).statement

          expect(statement.first.created_at).to be >= statement_first_day
          expect(statement.last.created_at).to be <= Time.zone.today.end_of_day
        end
      end

      context 'quando a quantidade de dias informada é 1' do
        it 'retorna as transações do dia atual' do
          account = create(:account, limit: 1000.0, balance: 1800.0)
          days = 1

          create_list(
            :account_transaction, 3, :withdraw,
            account: account, amount: 100.0, created_at: (Time.zone.today - 2.days)
          )

          create_list(
            :account_transaction, 3, :deposit, account: account, amount: 200.0
          )

          statement_first_day = Time.zone.today.beginning_of_day
          statement = described_class.new(token: account.user.token, days: days).statement

          expect(statement.first.created_at).to be >= statement_first_day
          expect(statement.last.created_at).to be <= Time.zone.today.end_of_day
        end
      end

      context 'quando a quantidade de dias informada é maior que 90' do
        it 'NÃO retorna o extrato' do
          account = create(:account, limit: 1000.0, balance: 1800.0)
          days = 100

          create_list(
            :account_transaction, 3, :deposit, account: account, amount: 200.0
          )

          statement = described_class.new(token: account.user.token, days: days).statement

          expect(statement).to be_nil
        end
      end
    end
  end

  describe '.statement' do
    it 'inicia o serviço, executa e retorna o resultado de #statement' do
      token = 'DuMMytOkeN'
      days = 10

      service = instance_double('AccountStatementService')
      account_transaction = instance_double('AccountTransaction')

      expect(described_class).to receive(:new).with(
        token: token, days: days
      ).once.and_return(service)
      expect(service).to receive(:statement).and_return(account_transaction)
      expect(described_class.statement(
        token: token, days: days
      )).to eq(account_transaction)
    end
  end
end
