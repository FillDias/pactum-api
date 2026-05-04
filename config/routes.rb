Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/register",        to: "auth#register"
      post "auth/login",           to: "auth#login"
      post "auth/refresh",         to: "auth#refresh"
      post "auth/forgot_password", to: "auth#forgot_password"
      post "auth/reset_password",  to: "auth#reset_password"
      get  "auth/verify_email",    to: "auth#verify_email"
      delete "auth/logout",        to: "auth#logout"

      resource :perfil, only: [:show, :update]

      get  "familias/atual",  to: "familias#atual"
      get  "familias/codigo", to: "familias#codigo"
      post "familias/entrar", to: "familias#entrar"

      resources :familias, only: [:create, :show] do
        member do
          post :convidar
        end
      end

      resources :lancamentos,   only: [:index, :create, :update, :destroy]
      resources :investimentos,  only: [:index, :create, :update, :destroy]
      resources :mensagens,     only: [:index, :create]
      resources :metas,         only: [:index, :create, :update, :destroy]

      get "saldo", to: "saldo#index"
    end
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
