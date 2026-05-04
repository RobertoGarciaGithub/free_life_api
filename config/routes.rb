# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  devise_for :users,
             path: 'api/v1/auth',
             path_names: {
               sign_in:      'login',
               sign_out:     'logout',
               registration: 'register'
             },
             controllers: {
               sessions:      'api/v1/auth/sessions',
               registrations: 'api/v1/auth/registrations'
             },
             defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      resources :users
      resources :banks
      resources :accounts
      resources :transactions
      resources :enterprises
      resources :categories
      resources :ofx, only: [:create]
    end
  end
end
