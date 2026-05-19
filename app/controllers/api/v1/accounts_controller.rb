module Api
  module V1
    class AccountsController < ApplicationController
      before_action :set_account, only: %i[show update destroy]

      def index
        accounts = Account.all
        render json: accounts, status: :ok
      end

      def show
        render json: @account, status: :ok
      end

      def create
        account = Account.new(account_params)

        if account.save
          render json: account, status: :created
        else
          render json: { errors: account.errors }, status: :unprocessable_content
        end
      end

      def update
        if @account.update(account_params)
          render json: @account, status: :ok
        else
          render json: { errors: @account.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @account.destroy
        head :no_content
      end

      private

      def set_account
        @account = Account.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Account not found' }, status: :not_found
      end

      def account_params
        params.expect(account: %i[amount profitability bank_id accountable_type accountable_id])
      end
    end
  end
end
