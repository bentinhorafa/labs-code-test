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

      def withdraw
        withdraw_request = AccountWithdrawService.new(
          token: request.headers['Authorization'],
          amount: withdraw_params[:amount]
        ).withdraw

        if withdraw_request
          cash_possibilities = withdraw_request.cash_possibilities.split('|')
          possibilities = normalized_possibilities(cash_possibilities)

          render(
            json: {
              message: 'Responda "1" para a opção 1 e "2" para a opção 2',
              id: withdraw_request.id,
              amount: withdraw_request.amount.to_i,
              cash_possibilities: possibilities
            },
            status: :created
          )
        else
          render json: { message: 'Requisição de saque não autorizada!' },
                 status: :forbidden
        end
      end

      def confirm
        withdraw_id = withdraw_confirm_params[:account_withdraw_request_id]
        account_withdraw_request = AccountWithdrawRequest.where(id: withdraw_id).last

        if account_withdraw_request.nil?
          return render(json: { message: 'Requisição de saque não encontrada!' },
                        status: :not_found)
        end

        withdraw_transaction = WithdrawConfirmService.new(
          token: request.headers['Authorization'],
          account_withdraw_request: account_withdraw_request,
          possibility: withdraw_confirm_params[:possibility]
        ).confirm

        if withdraw_transaction
          render(
            json: {
              message: 'Saque realizado com sucesso!',
              amount: withdraw_transaction.amount.to_i,
              balance: withdraw_transaction.account.balance.to_f
            },
            status: :created
          )
        else
          render json: { message: 'Saque não autorizado!' },
                 status: :forbidden
        end
      end

      private

      def normalized_possibilities(cash_possibilities)
        possibilities = []

        cash_possibilities.each do |possibility|
          temp_array = []

          possibility.split('-').each do |quantity_money|
            quantity = quantity_money.split('x').first
            money = quantity_money.split('x').last

            temp_array << "#{quantity} nota(s) de #{money}"
          end

          possibilities << temp_array.join(', ')
        end

        possibilities
      end

      def limit_params
        params.permit(:token, :limit)
      end

      def deposit_params
        params.permit(:amount)
      end

      def withdraw_params
        params.permit(:amount)
      end

      def withdraw_confirm_params
        params.permit(:account_withdraw_request_id, :possibility)
      end
    end
  end
end
