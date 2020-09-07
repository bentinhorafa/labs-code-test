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

      private

      def limit_params
        params.permit(:token, :limit)
      end
    end
  end
end
