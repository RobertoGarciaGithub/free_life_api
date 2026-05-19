module Api
  module V1
    class BanksController < ApplicationController
      before_action :set_bank, only: %i[show update destroy]

      def index
        banks = Bank.all
        render json: banks, status: :ok
      end

      def show
        render json: @bank, status: :ok
      end

      def create
        bank = Bank.new(bank_params)

        if bank.save
          render json: bank, status: :created
        else
          render json: { errors: bank.errors }, status: :unprocessable_content
        end
      end

      def update
        if @bank.update(bank_params)
          render json: @bank, status: :ok
        else
          render json: { errors: @bank.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @bank.destroy
        head :no_content
      end

      private

      def set_bank
        @bank = Bank.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Bank not found' }, status: :not_found
      end

      def bank_params
        params.expect(bank: %i[name code])
      end
    end
  end
end
