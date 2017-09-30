# frozen_string_literal: true

App1::Application.routes.draw do
  resources :profiles
  resources :tasks

  devise_for :users

  root to: 'tasks#index'

  namespace :api do
    namespace :v1 do
      resources :tasks
      resources :users
    end
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth' # , base_controller: 'Api::V1::BaseController'
    end
  end

  authenticated do
    root to: "secret#index", as: :authenticated_root
  end
end
