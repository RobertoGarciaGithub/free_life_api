module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_transaction, only: %i[show update destroy]

      def index
        transactions = Transaction.all
        render json: transactions, status: :ok
      end

      def show
        render json: @transaction, status: :ok
      end

      def create
        transaction = Transaction.new(transaction_params)

        if transaction.save
          render json: transaction, status: :created
        else
          render json: { errors: transaction.errors }, status: :unprocessable_content
        end
      end

      def update
        if @transaction.update(transaction_params)
          render json: @transaction, status: :ok
        else
          render json: { errors: @transaction.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @transaction.destroy
        head :no_content
      end

      private

      def set_transaction
        @transaction = Transaction.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Transaction not found' }, status: :not_found
      end

      def transaction_params
        params.expect(transaction: %i[amount description transactions_type status fitid user_id
                                      transactable_type transactable_id target_type target_id])
      end
    end
  end
end
