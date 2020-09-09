Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:create]

      put '/accounts/:token/update_limit', to: 'accounts#update', as: 'update_limit'
      post '/accounts/deposit', to: 'accounts#deposit', as: 'deposit'
      post '/accounts/withdraw_request', to: 'accounts#withdraw', as: 'withdraw_request'
    end
  end
end
