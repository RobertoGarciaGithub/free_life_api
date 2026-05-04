# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::EnterprisesController', type: :request do
  include_context 'with authenticated user'

  describe 'GET /api/v1/enterprises' do
    context 'when there are records' do
      before do
        create(:enterprise)
        get '/api/v1/enterprises', headers: auth_headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).not_to be_empty }
    end

    context 'when there are no records' do
      before { get '/api/v1/enterprises', headers: auth_headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to be_empty }
    end
  end

  describe 'GET /api/v1/enterprises/:id' do
    context 'when the enterprise exists' do
      let!(:enterprise) { create(:enterprise) }

      before { get "/api/v1/enterprises/#{enterprise.id}", headers: auth_headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'when the enterprise does not exist' do
      before { get '/api/v1/enterprises/00000000-0000-0000-0000-000000000000', headers: auth_headers }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'POST /api/v1/enterprises' do
    context 'with valid params' do
      let(:owner) { create(:user) }
      let(:params) do
        { enterprise: { legal_name: 'Empresa LTDA', cnpj: '11.222.333/0001-44',
                        owner_id: owner.id } }
      end

      before { post '/api/v1/enterprises', params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'with invalid params' do
      let(:params) { { enterprise: { legal_name: nil, cnpj: '11.222.333/0001-44' } } }

      before { post '/api/v1/enterprises', params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end
  end

  describe 'PATCH /api/v1/enterprises/:id' do
    context 'when the enterprise exists and params are valid' do
      let!(:enterprise) { create(:enterprise) }
      let(:params) { { enterprise: { legal_name: 'Updated LTDA' } } }

      before { patch "/api/v1/enterprises/#{enterprise.id}", params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body['legal_name']).to eq('Updated LTDA') }
    end

    context 'when the enterprise exists and params are invalid' do
      let!(:enterprise) { create(:enterprise) }
      let(:params) { { enterprise: { legal_name: nil } } }

      before { patch "/api/v1/enterprises/#{enterprise.id}", params: params, headers: auth_headers, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end

    context 'when the enterprise does not exist' do
      let(:params) { { enterprise: { legal_name: 'Updated LTDA' } } }

      before do
        patch '/api/v1/enterprises/00000000-0000-0000-0000-000000000000',
              params: params, headers: auth_headers, as: :json
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'DELETE /api/v1/enterprises/:id' do
    context 'when the enterprise exists' do
      let!(:enterprise) { create(:enterprise) }

      before { delete "/api/v1/enterprises/#{enterprise.id}", headers: auth_headers }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when the enterprise does not exist' do
      before { delete '/api/v1/enterprises/00000000-0000-0000-0000-000000000000', headers: auth_headers }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end
end
