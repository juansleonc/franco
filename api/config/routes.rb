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

    # Milestone 4: automation & dunning
    post "invoicing/generate_monthly", to: "invoicing#generate_monthly"
    get "dunning/candidates", to: "dunning#candidates"
    get "dunning/preview", to: "dunning#preview"
    post "dunning/send_bulk", to: "dunning#send_bulk"

    # Milestone 5: admin fees & owner statements
    post "fees/calculate", to: "fees#calculate"
    resources :owner_statements, only: %i[index show]

    # Milestone 6: dedup, notifications, banking (optional)
    namespace :dedup do
      get ":entity/candidates", to: "dedup#candidates", as: :candidates
    end
    post "dedup/merge", to: "dedup#merge"

    namespace :notifications do
      post "send_test", to: "notifications#send_test"
      post "send_test_sms", to: "notifications#send_test_sms"
      post "dunning_email", to: "notifications#dunning_email"
      post "dunning_sms", to: "notifications#dunning_sms"
    end

    namespace :banking do
      get "accounts", to: "banking#accounts"
      post "sync", to: "banking#sync"
    end
  end

  # rails health
  get "up" => "rails/health#show", as: :rails_health_check
end
