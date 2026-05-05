# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        skip_before_action :authenticate_user!, only: [:create]

        private

        def respond_with(resource, _opts = {})
          render json: {
            token: request.env['warden-jwt_auth.token'],
            user: {
              id: resource.id,
              email: resource.email,
              first_name: resource.first_name,
              last_name: resource.last_name
            }
          }, status: :ok
        end

        def respond_to_on_destroy
          render json: { message: 'Signed out successfully' }, status: :ok
        end
      end
    end
  end
end
