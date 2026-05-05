# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::AccountsController', type: :request do
  include_context 'with authenticated user'

  describe 'GET /api/v1/accounts' do
    context 'when there are records' do
      before do
        create(:account)
        get '/api/v1/accounts', headers: auth_headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).not_to be_empty }
    end

    context 'when there are no records' do
      before { get '/api/v1/accounts', headers: auth_headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to be_empty }
    end
  end

  describe 'GET /api/v1/accounts/:id' do
    context 'when the account exists' do
      let!(:account) { create(:account) }

      before { get "/api/v1/accounts/#{account.id}", headers: auth_headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'when the account does not exist' do
      before { get '/api/v1/accounts/00000000-0000-0000-0000-000000000000', headers: auth_headers }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'POST /api/v1/accounts' do
    context 'with valid params' do
      let(:user) { create(:user) }
      let(:bank) { create(:bank) }
      let(:params) do
        { account: { amount: 1000, profitability: 5, bank_id: bank.id, accountable_type: 'User',
                     accountable_id: user.id } }
      end

      before { post '/api/v1/accounts', params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'with invalid params' do
      let(:user) { create(:user) }
      let(:bank) { create(:bank) }
      let(:params) do
        { account: { amount: 1000, profitability: nil, bank_id: bank.id, accountable_type: 'User',
                     accountable_id: user.id } }
      end

      before { post '/api/v1/accounts', params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end
  end

  describe 'PATCH /api/v1/accounts/:id' do
    context 'when the account exists and params are valid' do
      let!(:account) { create(:account) }
      let(:params) { { account: { profitability: 10 } } }

      before do
        patch "/api/v1/accounts/#{account.id}", params: params, headers: auth_headers, as: :json
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body['profitability']).to eq(10) }
    end

    context 'when the account exists and params are invalid' do
      let!(:account) { create(:account) }
      let(:params) { { account: { profitability: nil } } }

      before do
        patch "/api/v1/accounts/#{account.id}", params: params, headers: auth_headers, as: :json
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end

    context 'when the account does not exist' do
      let(:params) { { account: { profitability: 10 } } }

      before do
        patch '/api/v1/accounts/00000000-0000-0000-0000-000000000000',
              params: params, headers: auth_headers, as: :json
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'DELETE /api/v1/accounts/:id' do
    context 'when the account exists' do
      let!(:account) { create(:account) }

      before { delete "/api/v1/accounts/#{account.id}", headers: auth_headers }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when the account does not exist' do
      before do
        delete '/api/v1/accounts/00000000-0000-0000-0000-000000000000', headers: auth_headers
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end
end
