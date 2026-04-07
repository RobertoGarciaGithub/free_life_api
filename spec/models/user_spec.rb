require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'factory' do
    it { expect(build(:user)).to be_valid }
  end

  describe 'validations' do
    context 'when all attributes are valid' do
      it { expect(user).to be_valid }
    end

    describe '#first_name' do
      let(:first_name) { nil }

      before do
        user.first_name = first_name
        user.valid?
      end

      it { expect(user).not_to be_valid }
      it { expect(user.errors[:first_name]).to include("can't be blank") }
    end

    describe '#last_name' do
      let(:last_name) { nil }

      before do
        user.last_name = last_name
        user.valid?
      end

      it { expect(user).not_to be_valid }
      it { expect(user.errors[:last_name]).to include("can't be blank") }
    end

    describe '#email' do
      context 'when nil' do
        let(:email) { nil }

        before do
          user.email = email
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:email]).to include("can't be blank") }
      end

      context 'when blank' do
        let(:email) { '   ' }

        before do
          user.email = email
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:email]).to include("can't be blank") }
      end

      context 'when already taken' do
        let(:existing_user) { create(:user) }
        let(:email) { existing_user.email }

        before do
          user.email = email
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:email]).to include('has already been taken') }
      end
    end

    describe '#document' do
      context 'when nil' do
        let(:document) { nil }

        before do
          user.document = document
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:document]).to include("can't be blank") }
      end

      context 'when blank' do
        let(:document) { '   ' }

        before do
          user.document = document
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:document]).to include("can't be blank") }
      end

      context 'when already taken' do
        let(:existing_user) { create(:user) }
        let(:document) { existing_user.document }

        before do
          user.document = document
          user.valid?
        end

        it { expect(user).not_to be_valid }
        it { expect(user.errors[:document]).to include('has already been taken') }
      end
    end
  end

  describe 'database columns' do
    it { expect(user).to respond_to(:first_name) }
    it { expect(user).to respond_to(:last_name) }
    it { expect(user).to respond_to(:email) }
    it { expect(user).to respond_to(:document) }
    it { expect(user).to respond_to(:created_at) }
    it { expect(user).to respond_to(:updated_at) }
  end

  describe 'UUID primary key' do
    let(:persisted_user) { create(:user) }

    it do
      expect(persisted_user.id).to \
        match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
