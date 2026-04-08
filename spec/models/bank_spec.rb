require 'rails_helper'

RSpec.describe Bank, type: :model do
  subject(:bank) { build(:bank) }

  describe 'factory' do
    it { expect(build(:bank)).to be_valid }
  end

  describe 'validations' do
    context 'when all attributes are valid' do
      it { expect(bank).to be_valid }
    end

    describe '#name' do
      let(:name) { nil }

      before do
        bank.name = name
        bank.valid?
      end

      it { expect(bank).not_to be_valid }
      it { expect(bank.errors[:name]).to include("can't be blank") }
    end

    describe '#code' do
      context 'when nil' do
        let(:code) { nil }

        before do
          bank.code = code
          bank.valid?
        end

        it { expect(bank).not_to be_valid }
        it { expect(bank.errors[:code]).to include("can't be blank") }
      end

      context 'when already taken' do
        let(:existing_bank) { create(:bank) }
        let(:code) { existing_bank.code }

        before do
          bank.code = code
          bank.valid?
        end

        it { expect(bank).not_to be_valid }
        it { expect(bank.errors[:code]).to include('has already been taken') }
      end
    end
  end

  describe 'database columns' do
    it { expect(bank).to respond_to(:name) }
    it { expect(bank).to respond_to(:code) }
    it { expect(bank).to respond_to(:created_at) }
    it { expect(bank).to respond_to(:updated_at) }
  end

  describe 'UUID primary key' do
    let(:persisted_bank) { create(:bank) }

    it do
      expect(persisted_bank.id).to \
        match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
