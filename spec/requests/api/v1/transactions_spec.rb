require 'rails_helper'

RSpec.describe 'Api::V1::TransactionsController', type: :request do
  describe 'GET /api/v1/transactions' do
    context 'when there are records' do
      before do
        create(:transaction)
        get '/api/v1/transactions'
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).not_to be_empty }
    end

    context 'when there are no records' do
      before { get '/api/v1/transactions' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to be_empty }
    end
  end

  describe 'GET /api/v1/transactions/:id' do
    context 'when the transaction exists' do
      let!(:transaction) { create(:transaction) }

      before { get "/api/v1/transactions/#{transaction.id}" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'when the transaction does not exist' do
      before { get '/api/v1/transactions/00000000-0000-0000-0000-000000000000' }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'POST /api/v1/transactions' do
    context 'with valid params' do
      let(:user) { create(:user) }
      let(:account) { create(:account) }
      let(:params) do
        {
          transaction: {
            amount: 250,
            description: 'Pagamento',
            transactions_type: 'debit',
            status: 'pending',
            transactable_type: 'Account',
            transactable_id: account.id,
            user_id: user.id
          }
        }
      end

      before { post '/api/v1/transactions', params: params, as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'with invalid params' do
      let(:user) { create(:user) }
      let(:account) { create(:account) }
      let(:params) do
        {
          transaction: {
            amount: nil,
            description: nil,
            transactions_type: 'debit',
            status: 'pending',
            transactable_type: 'Account',
            transactable_id: account.id,
            user_id: user.id
          }
        }
      end

      before { post '/api/v1/transactions', params: params, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end
  end

  describe 'PATCH /api/v1/transactions/:id' do
    context 'when the transaction exists and params are valid' do
      let!(:transaction) { create(:transaction) }
      let(:params) { { transaction: { description: 'Updated Description', status: 'completed' } } }

      before { patch "/api/v1/transactions/#{transaction.id}", params: params, as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body['description']).to eq('Updated Description') }
    end

    context 'when the transaction exists and params are invalid' do
      let!(:transaction) { create(:transaction) }
      let(:params) { { transaction: { description: nil } } }

      before { patch "/api/v1/transactions/#{transaction.id}", params: params, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end

    context 'when the transaction does not exist' do
      let(:params) { { transaction: { description: 'Updated Description' } } }

      before do
        patch '/api/v1/transactions/00000000-0000-0000-0000-000000000000', params: params, as: :json
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'DELETE /api/v1/transactions/:id' do
    context 'when the transaction exists' do
      let!(:transaction) { create(:transaction) }

      before { delete "/api/v1/transactions/#{transaction.id}" }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when the transaction does not exist' do
      before { delete '/api/v1/transactions/00000000-0000-0000-0000-000000000000' }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end
end
