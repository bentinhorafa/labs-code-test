module Api
  module V1
    class AccountsController < ApplicationController
      def update
        account = AccountLimitUpdateService.new(
          token: limit_params[:token],
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

      private

      def limit_params
        params.permit(:token, :limit)
      end

      def deposit_params
        params.permit(:amount)
      end
    end
  end
end
