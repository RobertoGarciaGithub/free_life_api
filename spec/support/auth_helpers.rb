# frozen_string_literal: true

module AuthHelpers
  def auth_headers_for(user)
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end
end

RSpec.shared_context 'with authenticated user' do
  let(:current_user) { create(:user) }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
end
