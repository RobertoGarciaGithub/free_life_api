module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors }, status: :unprocessable_content
        end
      end

      private

      def user_params
        params.expect(user: %i[first_name last_name email document])
      end
    end
  end
end
