# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'GET /show' do
    let(:subscription) { create(:subscription) }

    it 'renders the show template' do
      get plan_subscription_path(subscription.plan, subscription)

      expect(response.body).to include("Subscription details for #{subscription.plan.title}")
    end
  end

  describe 'POST /create' do
    let(:plan) { create(:plan) }

    context 'when the subscription is successfull' do
      it 'creates a subscription for the current plan' do
        expect do
          post plan_subscriptions_path(plan)
        end.to change(Subscription, :count).by(1)

        expect(Subscription.last.plan).to eq(plan)
        expect(Subscription.last.unit_price).to eq(plan.unit_price)
        expect(response).to redirect_to(plan_subscription_path(plan, Subscription.last))
        expect(flash[:notice]).to eq('Subscription has been successfully created.')
      end
    end

    context 'when the subscription is NOT successfull' do
      it 'does not create a subscription for the current plan' do
        allow_any_instance_of(Subscription).to receive(:save).and_return(false)

        expect do
          post plan_subscriptions_path(plan)
        end.to change(Subscription, :count).by(0)

        expect(response).to redirect_to(plan_path(plan))
        expect(flash[:alert]).to eq('An error occurred while creating the subscription. Please try again.')
      end
    end
  end

  describe 'POST /apply_coupon' do
    let(:subscription) { create(:subscription) }
    let(:coupon) { create(:coupon) }

    it 'applies a coupon to a subscription' do
      post apply_coupon_plan_subscription_path(subscription.plan, subscription, coupon.id)

      expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
      expect(flash[:notice]).to eq('Coupon has been successfully applied.')
    end

    it 'fails to apply an invalid coupon to a subscription' do
      coupon.update!(max_uses: 1)

      2.times do
        post apply_coupon_plan_subscription_path(subscription.plan, subscription, coupon.id)
      end

      expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
      expect(flash[:alert]).to eq('Invalid coupon or it has reached its maximum uses.')
    end
  end
end
