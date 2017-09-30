# frozen_string_literal: true

module Api::V1
  class UsersController < Api::BaseController
    # before_action :authenticate_user!, except: [:new, :create]
    # skip_before_filter :verify_authenticity_token

    def show
      render json: current_user.to_json
    end

=begin
    def create
      current_user.tasks.build(permitted_params).save!
      render json: {}, status: :created
    end

    def permitted_params
      params.require(:task).permit(:description)
    end
=end
  end
end
