# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'POST /apply_coupon' do
    let(:subscription) { create(:subscription) }
    let(:coupon) { create(:coupon) }

    it 'applies a coupon to a subscription' do
      post apply_coupon_subscription_path(subscription, coupon.id)

      expect(response).to redirect_to(subscription_path(subscription))
      expect(flash[:notice]).to eq('Coupon has been successfully applied.')
    end

    it 'fails to apply an invalid coupon to a subscription' do
      coupon.update!(max_uses: 1)

      2.times do
        post apply_coupon_subscription_path(subscription, coupon.id)
      end

      expect(response).to redirect_to(subscription_path(subscription))
      expect(flash[:alert]).to eq('Invalid coupon or it has reached its maximum uses.')
    end
  end
end
