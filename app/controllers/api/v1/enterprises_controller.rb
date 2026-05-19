module Api
  module V1
    class EnterprisesController < ApplicationController
      before_action :set_enterprise, only: %i[show update destroy]

      def index
        enterprises = Enterprise.all
        render json: enterprises, status: :ok
      end

      def show
        render json: @enterprise, status: :ok
      end

      def create
        enterprise = Enterprise.new(enterprise_params)

        if enterprise.save
          render json: enterprise, status: :created
        else
          render json: { errors: enterprise.errors }, status: :unprocessable_content
        end
      end

      def update
        if @enterprise.update(enterprise_params)
          render json: @enterprise, status: :ok
        else
          render json: { errors: @enterprise.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @enterprise.destroy
        head :no_content
      end

      private

      def set_enterprise
        @enterprise = Enterprise.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Enterprise not found' }, status: :not_found
      end

      def enterprise_params
        params.expect(enterprise: %i[legal_name trade_name cnpj owner_id])
      end
    end
  end
end
