# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!
  end
end
