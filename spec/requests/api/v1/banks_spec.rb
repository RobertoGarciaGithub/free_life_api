require 'rails_helper'

RSpec.describe 'Api::V1::BanksController', type: :request do
  describe 'GET /api/v1/banks' do
    context 'when there are records' do
      before do
        create(:bank)
        get '/api/v1/banks'
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).not_to be_empty }
    end

    context 'when there are no records' do
      before { get '/api/v1/banks' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to be_empty }
    end
  end

  describe 'GET /api/v1/banks/:id' do
    context 'when the bank exists' do
      let!(:bank) { create(:bank) }

      before { get "/api/v1/banks/#{bank.id}" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'when the bank does not exist' do
      before { get '/api/v1/banks/00000000-0000-0000-0000-000000000000' }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'POST /api/v1/banks' do
    context 'with valid params' do
      let(:bank) { build(:bank) }
      let(:params) { { bank: { name: bank.name, code: bank.code } } }

      before { post '/api/v1/banks', params: params, as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'with invalid params' do
      let(:params) { { bank: { name: nil, code: '001' } } }

      before { post '/api/v1/banks', params: params, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end
  end

  describe 'PATCH /api/v1/banks/:id' do
    context 'when the bank exists and params are valid' do
      let!(:bank) { create(:bank) }
      let(:params) { { bank: { name: 'Updated Bank' } } }

      before { patch "/api/v1/banks/#{bank.id}", params: params, as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body['name']).to eq('Updated Bank') }
    end

    context 'when the bank exists and params are invalid' do
      let!(:bank) { create(:bank) }
      let(:params) { { bank: { name: nil } } }

      before { patch "/api/v1/banks/#{bank.id}", params: params, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end

    context 'when the bank does not exist' do
      let(:params) { { bank: { name: 'Updated Bank' } } }

      before do
        patch '/api/v1/banks/00000000-0000-0000-0000-000000000000', params: params, as: :json
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end

  describe 'DELETE /api/v1/banks/:id' do
    context 'when the bank exists' do
      let!(:bank) { create(:bank) }

      before { delete "/api/v1/banks/#{bank.id}" }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when the bank does not exist' do
      before { delete '/api/v1/banks/00000000-0000-0000-0000-000000000000' }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.parsed_body).to have_key('error') }
    end
  end
end
