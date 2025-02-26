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

    describe '#validate_editable' do
      context 'coupon is not applied' do
        it 'updates its' do
          subject.update(percentage: 50)

          expect(subject.reload).to be_valid
        end
      end

      context 'coupon is applied at least once' do
        it 'does not updates its but throw a validation error' do
          create(:subscription_coupon, coupon: subject)
          subject.update(percentage: 50)

          expect(subject.reload.errors.full_messages).to include('Coupon is already in use and cannot be edited')
        end
      end
    end
  end

  describe 'callbacks' do
    describe '#generate_unique_code' do
      let(:coupon) { create(:coupon) }

      it 'generates a unique code' do
        expect(coupon.code).to be_present
      end
    end
  end

  describe 'instance methods' do
    describe '#apllied?' do
      let!(:coupon) { create(:coupon_with_subscription_coupon) }

      it { expect(coupon.reload.apllied?).to be_truthy }

      it 'returns false if coupon is not applied' do
        coupon.subscription_coupons.destroy_all

        expect(coupon.reload.apllied?).to be_falsy
      end
    end
  end
end
