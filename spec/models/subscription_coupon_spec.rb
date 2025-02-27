# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionCoupon, type: :model do
  describe 'Associations' do
    it { should belong_to(:subscription) }
    it { should belong_to(:coupon) }
  end

  describe 'Callbacks' do
    context 'when only one coupon is applied' do
      it 'updates the subscription unit price and enqueues a background job' do
        subscription = create(:subscription, unit_price: 10_000)
        coupon = create(:coupon, percentage: 10)

        expect do
          create(:subscription_coupon, subscription:, coupon:)
          expect(subscription.reload.unit_price).to eq(9000)
        end.to have_enqueued_job(NotifyPaymentProviderJob).with(subscription.id)
      end

      context 'when stacked coupons are applied' do
        it 'updates the subscription unit price and enqueues a background job' do
          subscription = create(:subscription, unit_price: 10_000)
          coupon1 = create(:coupon, percentage: 10)
          coupon2 = create(:coupon, percentage: 20)
          coupon3 = create(:coupon, percentage: 10)

          expect do
            create(:subscription_coupon, subscription:, coupon: coupon1)
            create(:subscription_coupon, subscription:, coupon: coupon2)
            create(:subscription_coupon, subscription:, coupon: coupon3)

            expect(subscription.reload.unit_price).to eq(6000)
          end.to have_enqueued_job(NotifyPaymentProviderJob).with(subscription.id).exactly(3).times
        end
      end
    end
  end
end
