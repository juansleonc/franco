Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    resource :health, only: [:show]
  end

  # rails health
  get "up" => "rails/health#show", as: :rails_health_check
end
