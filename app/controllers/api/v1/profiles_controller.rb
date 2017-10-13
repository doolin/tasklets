# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: Profile.first.to_json
      end

      def create
        current_user.build_profile(permitted_params).save!
        render json: {}, status: :created
      end

      def permitted_params
        params.require(:profile).permit(:firstname)
      end
    end
  end
end
