require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:category_type) }
    it { is_expected.to validate_numericality_of(:budget).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:icon) }
  end
end
