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
      post apply_coupon_plan_subscription_path(subscription.plan, subscription),
           params: { subscription: { coupon_code: coupon.code } }

      expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
      expect(flash[:notice]).to eq('Coupon has been successfully applied.')
    end

    it 'fails to apply an invalid coupon to a subscription' do
      coupon.update!(max_uses: 1)

      2.times do
        post apply_coupon_plan_subscription_path(subscription.plan, subscription),
             params: { subscription: { coupon_code: coupon.code } }
      end

      expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
      expect(flash[:alert]).to eq('Invalid coupon or it has reached its maximum uses.')
    end
  end

  describe 'POST /remove_coupon' do
    let(:plan) { create(:plan, unit_price: 10_000) }
    let(:subscription) { create(:subscription, plan:) }
    let(:coupon) { create(:coupon, percentage: 10) }

    before { subscription.apply_coupon(coupon.code) }

    context 'when only one coupon is applied' do
      it 'removes the coupon from a subscription and reeset the unit price to the plan original unit price' do
        expect(subscription.unit_price).to eq(9000)

        expect do
          delete remove_coupon_plan_subscription_path(subscription.plan, subscription, coupon_id: coupon.id)
        end.to change(SubscriptionCoupon, :count).by(-1)

        expect(subscription.reload.unit_price).to eq(10_000)
        expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
        expect(flash[:notice]).to eq('Coupon has been successfully removed.')
      end
    end

    context 'when multiple coupons are applied' do
      it 'removes the coupon from a subscription and recalculates the unit price' do
        coupon2 = create(:coupon, percentage: 5)
        subscription.apply_coupon(coupon2.code)

        expect(subscription.unit_price).to eq(8500)

        expect do
          delete remove_coupon_plan_subscription_path(subscription.plan, subscription, coupon_id: coupon.id)
        end.to change(SubscriptionCoupon, :count).by(-1)

        expect(subscription.reload.unit_price).to eq(9500)
        expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
        expect(flash[:notice]).to eq('Coupon has been successfully removed.')
      end
    end

    context 'when removing a coupon fails' do
      it 'fails to remove the coupon from a subscription' do
        allow_any_instance_of(Subscription).to receive(:remove_coupon).and_return(false)

        expect do
          delete remove_coupon_plan_subscription_path(subscription.plan, subscription, coupon_id: coupon.id)
        end.to change(SubscriptionCoupon, :count).by(0)

        expect(response).to redirect_to(plan_subscription_path(subscription.plan, subscription))
        expect(flash[:alert]).to eq('Coupon could not be remived. Please try again.')
      end
    end
  end
end
