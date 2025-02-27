# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'plans#index'

  resources :plans, only: %i[index show] do
    resources :subscriptions, only: %i[create show] do
      post 'apply_coupon', to: 'subscriptions#apply_coupon', as: :apply_coupon, on: :member
    end
  end

  resources :coupons, only: %i[index show new create edit update]
end
