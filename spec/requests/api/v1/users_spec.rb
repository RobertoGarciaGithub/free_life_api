require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST /api/v1/users' do
    context 'with valid params' do
      let(:user) { build(:user) }
      let(:params) do
        { user: { first_name: user.first_name, last_name: user.last_name, email: user.email,
                  document: user.document } }
      end

      before { post '/api/v1/users', params: params, as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body).to have_key('id') }
    end

    context 'with invalid params (email nil)' do
      let(:user) { build(:user) }
      let(:params) do
        { user: { first_name: user.first_name, last_name: user.last_name, email: nil,
                  document: user.document } }
      end

      before { post '/api/v1/users', params: params, as: :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body).to have_key('errors') }
    end
  end
end
