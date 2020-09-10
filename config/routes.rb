Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:create]

      put '/accounts/:token/update_limit', to: 'accounts#update', as: 'update_limit'
      post '/accounts/deposit', to: 'accounts#deposit', as: 'deposit'
      post '/accounts/transfer', to: 'accounts#transfer', as: 'transfer'

      get '/accounts/statement/:days', to: 'accounts#index'

      post '/accounts/withdraw_request', to: 'withdraws#withdraw', as: 'withdraw_request'
      post '/accounts/withdraw_confirm', to: 'withdraws#confirm', as: 'withdraw_confirm'
    end
  end
end
