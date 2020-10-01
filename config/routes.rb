# frozen_string_literal: true

Tasklets::Application.routes.draw do
  resources :profiles
  resources :tasks

  devise_for :users

  root to: 'tasks#index'

  namespace :api do
    namespace :v1 do
      resources :profiles
      resources :tasks
      resources :users
    end
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth' # , base_controller: 'Api::V1::BaseController'
    end
  end

  # Devise authentication. This is a super kludge.
  # https://github.com/danmayer/coverband#mounting-as-a-rack-app
  # TODO: https://doolin.atlassian.net/browse/TASKLETS-114
  authenticate :user, ->(u) { u.id == 1 } do
    mount Coverband::Reporters::Web.new, at: '/coverage'
  end

  authenticated do
    root to: "secret#index", as: :authenticated_root
  end
end
