# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionCoupon, type: :model do
  describe 'Associations' do
    it { should belong_to(:subscription) }
    it { should belong_to(:coupon) }
  end

  describe 'Callbacks' do
    it 'updates the subscription unit price and enqueues a background job' do
      subscription = create(:subscription, unit_price: 10_000)
      coupon = create(:coupon, percentage: 10)

      expect do
        create(:subscription_coupon, subscription:, coupon:)
        expect(subscription.reload.unit_price).to eq(9000)
      end.to have_enqueued_job(NotifyPaymentProviderJob).with(subscription.id)
    end
  end
end
