require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { build(:account) }

  describe 'factory' do
    it { expect(build(:account)).to be_valid }
  end

  describe 'validations' do
    context 'when all attributes are valid' do
      it { expect(account).to be_valid }
    end

    describe '#amount' do
      context 'when nil' do
        before do
          account.amount_cents = nil
          account.valid?
        end

        it { expect(account).not_to be_valid }
        it { expect(account.errors[:amount]).to include("can't be blank") }
      end

      context 'when negative' do
        before do
          account.amount_cents = -1
          account.valid?
        end

        it { expect(account).not_to be_valid }
        it { expect(account.errors[:amount]).to include('must be greater than or equal to 0') }
      end
    end

    describe '#profitability' do
      context 'when nil' do
        before do
          account.profitability = nil
          account.valid?
        end

        it { expect(account).not_to be_valid }
        it { expect(account.errors[:profitability]).to include("can't be blank") }
      end

      context 'when not an integer' do
        before do
          account.profitability = 1.5
          account.valid?
        end

        it { expect(account).not_to be_valid }
        it { expect(account.errors[:profitability]).to include('must be an integer') }
      end
    end
  end

  describe 'database columns' do
    it { expect(account).to respond_to(:amount_cents) }
    it { expect(account).to respond_to(:profitability) }
    it { expect(account).to respond_to(:created_at) }
    it { expect(account).to respond_to(:updated_at) }
  end

  describe 'UUID primary key' do
    let(:persisted_account) { create(:account) }

    it do
      expect(persisted_account.id).to \
        match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
