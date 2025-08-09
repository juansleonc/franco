Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :v1 do
    post "auth/login", to: "auth#login"
    delete "auth/logout", to: "auth#logout"

    resource :health, only: [ :show ]
    resources :suppliers, only: [ :index, :create ] do
      collection do
        post :import
      end
    end
    resources :properties
    resources :tenants
    resources :contracts do
      collection do
        post :schedule_preview
      end
    end

    resources :invoices, only: %i[index show]
    resources :payments, only: %i[index create show update]
    resources :bank_statements, only: %i[show] do
      collection do
        post :import
      end
    end
    resources :statement_lines, only: [] do
      member do
        post :match
        post :ignore
      end
    end
  end

  # rails health
  get "up" => "rails/health#show", as: :rails_health_check
end
