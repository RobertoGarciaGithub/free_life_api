require 'rails_helper'

RSpec.describe Enterprise, type: :model do
  subject(:enterprise) { build(:enterprise) }

  describe 'factory' do
    it { expect(build(:enterprise)).to be_valid }
  end

  describe 'validations' do
    context 'when all attributes are valid' do
      it { expect(enterprise).to be_valid }
    end

    describe '#legal_name' do
      let(:legal_name) { nil }

      before do
        enterprise.legal_name = legal_name
        enterprise.valid?
      end

      it { expect(enterprise).not_to be_valid }
      it { expect(enterprise.errors[:legal_name]).to include("can't be blank") }
    end

    describe '#cnpj' do
      context 'when nil' do
        let(:cnpj) { nil }

        before do
          enterprise.cnpj = cnpj
          enterprise.valid?
        end

        it { expect(enterprise).not_to be_valid }
        it { expect(enterprise.errors[:cnpj]).to include("can't be blank") }
      end

      context 'when already taken' do
        let(:existing_enterprise) { create(:enterprise) }
        let(:cnpj) { existing_enterprise.cnpj }

        before do
          enterprise.cnpj = cnpj
          enterprise.valid?
        end

        it { expect(enterprise).not_to be_valid }
        it { expect(enterprise.errors[:cnpj]).to include('has already been taken') }
      end
    end
  end

  describe 'database columns' do
    it { expect(enterprise).to respond_to(:legal_name) }
    it { expect(enterprise).to respond_to(:trade_name) }
    it { expect(enterprise).to respond_to(:cnpj) }
    it { expect(enterprise).to respond_to(:created_at) }
    it { expect(enterprise).to respond_to(:updated_at) }
  end

  describe 'UUID primary key' do
    let(:persisted_enterprise) { create(:enterprise) }

    it do
      expect(persisted_enterprise.id).to \
        match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
