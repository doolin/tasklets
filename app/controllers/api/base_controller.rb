# frozen_string_literal: true

module Api
  class BaseController < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!, except: [:new, :create]
  end
end
