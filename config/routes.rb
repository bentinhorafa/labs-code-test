Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:create]

      put '/accounts/:token/update_limit', to: 'accounts#update', as: 'update_limit'
      post '/accounts/deposit', to: 'accounts#deposit', as: 'deposit'
      post '/accounts/withdraw_request', to: 'accounts#withdraw', as: 'withdraw_request'
      post '/accounts/withdraw_confirm', to: 'accounts#confirm', as: 'withdraw_confirm'
    end
  end
end
