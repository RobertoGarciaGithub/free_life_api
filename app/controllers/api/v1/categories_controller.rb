module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]

      def index
        categories = Category.all
        render json: categories, status: :ok
      end

      def show
        render json: @category, status: :ok
      end

      def create
        category = Category.new(category_params)

        if category.save
          render json: category, status: :created
        else
          render json: { errors: category.errors }, status: :unprocessable_content
        end
      end

      def update
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: { errors: @category.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @category.destroy
        head :no_content
      end

      private

      def set_category
        @category = Category.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Category not found' }, status: :not_found
      end

      def category_params
        params.expect(category: %i[name description])
      end
    end
  end
end
