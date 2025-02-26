# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'Associations' do
    it { should belong_to(:plan) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  end

  describe '#apply_coupon' do
    let(:subscription) { create(:subscription) }
    let(:coupon) { create(:coupon) }

    before do
      allow(Rails.logger).to receive(:error)
    end

    context 'when coupon is valid/active' do
      it 'applies the coupon and returns true' do
        subscription.update!(unit_price: 10_000)
        coupon.update!(percentage: 10)

        expect do
          expect(subscription.apply_coupon(coupon.id)).to eq(true)
        end.to change(SubscriptionCoupon, :count).by(1)

        expect(coupon.reload.used_count).to eq(1)
        expect(subscription.reload.unit_price).to eq(9000)
      end
    end

    context 'when coupon is invalid' do
      it 'returns false' do
        expect(subscription.apply_coupon(9999)).to eq(false)
      end
    end

    context 'when coupon has reached its maximum uses' do
      it 'returns false' do
        coupon.update!(used_count: coupon.max_uses)

        expect(subscription.apply_coupon(coupon.id)).to eq(false)
      end
    end

    context 'when coupon application fails' do
      it 'returns false' do
        allow(SubscriptionCoupon).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)

        expect(subscription.apply_coupon(coupon.id)).to eq(false)
        expect(Rails.logger).to have_received(:error)
          .with("Coupon (ID: #{coupon.id}) application failed: Record invalid")
      end
    end

    it 'ensures only one coupon application is allowed at a time to prevent race conditions' do
      coupon.update!(max_uses: 2)

      threads = []

      3.times do
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            subscription.apply_coupon(coupon.id)
          end
        end
      end

      threads.each(&:join) # This will wait for all threads to finish

      expect(coupon.reload.used_count).to be <= 2
      expect(SubscriptionCoupon.count).to be <= 2
    end

    context 'when a coupon is already applied at least once' do
      it 'does not apply it and returns false' do
        create(:subscription_coupon, subscription:, coupon:)

        expect(subscription.apply_coupon(coupon.id)).to eq(false)
        expect(SubscriptionCoupon.where(subscription:, coupon:).count).to eq(1)
      end
    end
  end
end
