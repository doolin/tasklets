# frozen_string_literal: true

App1::Application.routes.draw do
  resources :profiles
  resources :tasks

  devise_for :users

  root to: 'tasks#index'

  namespace :api do
    resources :tasks
    mount_devise_token_auth_for 'User', at: 'auth'
  end

  authenticated do
    root to: "secret#index", as: :authenticated_root
  end
end
