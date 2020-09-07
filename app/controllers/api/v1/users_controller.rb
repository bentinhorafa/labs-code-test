module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = UserCreateService.new(
          full_name: user_params[:full_name],
          document: user_params[:document],
          address: user_params[:address],
          birthday: user_params[:birthday],
          gender: user_params[:gender],
          password: user_params[:password]
        ).create

        if user.persisted?
          account = user.account

          render(
            json: {
              branch: account.account_number,
              account_number: account.account_number,
              token: user.token
            },
            status: :created
          )
        else
          render json: { message: user.errors.full_messages.join(', ') },
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :full_name, :document, :address, :birthday, :gender, :password
        )
      end
    end
  end
end
