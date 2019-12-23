# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(_errors)
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
