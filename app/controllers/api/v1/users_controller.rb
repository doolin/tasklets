# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def show
        render json: current_user.to_json
      end

      def create
        User.create! permitted_params
        render json: {}, status: :created
      end

      def permitted_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
