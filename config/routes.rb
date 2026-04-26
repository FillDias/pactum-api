Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login",    to: "auth#login"
      delete "auth/logout", to: "auth#logout"

      resource :perfil, only: [:show, :update]

      get "familias/atual", to: "familias#atual"

      resources :familias, only: [:create, :show] do
        member do
          post :convidar
        end
      end

      resources :lancamentos,   only: [:index, :create, :update, :destroy]
      resources :receitas,      only: [:index, :create, :update, :destroy]
      resources :investimentos,  only: [:index, :create, :update, :destroy]
      resources :mensagens,     only: [:index, :create]
      resources :metas,         only: [:index, :create, :update, :destroy]

      get "saldo", to: "saldo#index"
    end
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
