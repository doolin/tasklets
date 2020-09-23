# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user! # , except: [:new, :create]
    end
  end
end
