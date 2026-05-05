# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        skip_before_action :authenticate_user!, only: :create

        def create
          super
        end

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              user: {
                id: resource.id,
                email: resource.email,
                first_name: resource.first_name,
                last_name: resource.last_name
              }
            }, status: :created
          else
            render json: { errors: resource.errors.to_hash(full_messages: true) },
                   status: :unprocessable_content
          end
        end

        def sign_up_params
          params.expect(
            user: %i[email
                     password
                     password_confirmation
                     first_name
                     last_name
                     document]
          )
        end
      end
    end
  end
end
