# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
  end
end
