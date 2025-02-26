# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'associations' do
    it { should have_many(:subscription_coupons) }
  end

  describe 'validations' do
    subject { build(:coupon) }

    it 'presence of code' do
      subject.valid?

      expect(subject.code).to be_present
    end

    it { should validate_presence_of(:percentage) }
    it { should validate_numericality_of(:percentage).is_greater_than(0).is_less_than_or_equal_to(100) }
    it { should validate_presence_of(:max_uses) }
    it { should validate_numericality_of(:max_uses).is_greater_than(0) }
  end

  describe 'callbacks' do
    describe '#generate_unique_code' do
      let(:coupon) { create(:coupon) }

      it 'generates a unique code' do
        expect(coupon.code).to be_present
      end
    end
  end
end
