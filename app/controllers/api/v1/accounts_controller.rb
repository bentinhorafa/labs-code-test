module Api
  module V1
    class AccountsController < ApplicationController
      def update
        account = AccountLimitUpdateService.new(
          token: request.headers['Authorization'],
          limit: limit_params[:limit]
        ).update

        if account
          render(
            json: {
              message: 'Limite atualizado com sucesso!',
              limit: account.limit.to_f
            },
            status: :accepted
          )
        else
          render json: { message: 'Não autorizado!' },
                 status: :forbidden
        end
      end

      def deposit
        deposit_transaction = AccountDepositService.new(
          token: request.headers['Authorization'],
          amount: deposit_params[:amount]
        ).deposit

        if deposit_transaction
          render(
            json: {
              message: 'Depósito realizado com sucesso!',
              amount: deposit_transaction.amount.to_i,
              balance: deposit_transaction.account.balance.to_f
            },
            status: :created
          )
        else
          render json: { message: 'Depósito não autorizado!' },
                 status: :forbidden
        end
      end

      def transfer
        debit_transaction, credit_transaction = AccountTransferService.new(
          token: request.headers['Authorization'],
          destiny_branch: transfer_params[:destiny_branch],
          destiny_account_number: transfer_params[:destiny_account_number],
          amount: transfer_params[:amount]
        ).transfer

        if debit_transaction && credit_transaction
          origin_balance = debit_transaction.account.reload.balance.to_f

          render(
            json: {
              message: 'Transferência realizada com sucesso!',
              amount: debit_transaction.amount.to_i.abs,
              balance: origin_balance,
              transfer_to: credit_transaction.account.user.full_name
            },
            status: :created
          )
        else
          render json: { message: 'Transferência não autorizada!' },
                 status: :forbidden
        end
      end

      def statement
        statement = AccountStatementService.new(
          token: request.headers['Authorization'],
          days: statement_params[:days]
        ).statement

        if statement
          days = statement_params[:days]

          render(
            json: {
              message: "Saldo do(s) último(s) #{days} dia(s)",
              statement: normalized_statement(statement)
            },
            status: :ok
          )
        else
          render json: { message: 'Não foi possível verificar seu extrato.' },
                 status: :not_found
        end
      end

      def balance
        token = request.headers['Authorization']
        user = User.find_by(token: token)

        if user
          render json: { balance: user.account.balance.to_f }, status: :ok
        else
          render json: { message: 'Erro. Contate o administrador.' },
                 status: :forbidden
        end
      end

      private

      def normalized_statement(statement)
        transactions_message = []

        statement.each do |s|
          transactions_message << "#{s.created_at.strftime('%d/%m/%Y')} | " \
          "#{s.transaction_type.capitalize} | " \
          "R$ #{s.amount}"
        end

        transactions_message
      end

      def limit_params
        params.permit(:limit)
      end

      def deposit_params
        params.permit(:amount)
      end

      def transfer_params
        params.permit(:destiny_branch, :destiny_account_number, :amount)
      end

      def statement_params
        params.permit(:days)
      end
    end
  end
end
