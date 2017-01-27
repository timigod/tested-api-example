Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :tickets, only: [:create, :index] do
        member do
          post 'reply'
          post 'close'
          post 'reopen'
        end
      end
    end
  end

end
