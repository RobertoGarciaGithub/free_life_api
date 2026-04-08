require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { build(:transaction) }

  describe 'factory' do
    it { expect(build(:transaction)).to be_valid }
  end

  describe 'validations' do
    context 'when all attributes are valid' do
      it { expect(transaction).to be_valid }
    end

    describe '#amount' do
      context 'when nil' do
        before do
          transaction.amount_cents = nil
          transaction.valid?
        end

        it { expect(transaction).not_to be_valid }
        it { expect(transaction.errors[:amount]).to include("can't be blank") }
      end

      context 'when zero' do
        before do
          transaction.amount_cents = 0
          transaction.valid?
        end

        it { expect(transaction).not_to be_valid }
        it { expect(transaction.errors[:amount]).to include('must be greater than 0') }
      end
    end

    describe '#description' do
      let(:description) { nil }

      before do
        transaction.description = description
        transaction.valid?
      end

      it { expect(transaction).not_to be_valid }
      it { expect(transaction.errors[:description]).to include("can't be blank") }
    end
  end

  describe 'enums' do
    describe '#transactions_type' do
      it {
        expect(described_class.transactions_types).to include('debit' => 0, 'credit' => 1,
                                                              'transfer' => 2)
      }
    end

    describe '#status' do
      it {
        expect(described_class.statuses).to include('pending' => 0, 'completed' => 1,
                                                    'cancelled' => 2)
      }
    end
  end

  describe 'database columns' do
    it { expect(transaction).to respond_to(:amount_cents) }
    it { expect(transaction).to respond_to(:description) }
    it { expect(transaction).to respond_to(:transactions_type) }
    it { expect(transaction).to respond_to(:status) }
    it { expect(transaction).to respond_to(:created_at) }
    it { expect(transaction).to respond_to(:updated_at) }
  end

  describe 'UUID primary key' do
    let(:persisted_transaction) { create(:transaction) }

    it do
      expect(persisted_transaction.id).to \
        match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
