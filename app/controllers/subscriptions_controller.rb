# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show apply_coupon]

  def show; end

  def apply_coupon
    if @subscription.apply_coupon(params[:coupon_id])
      redirect_to subscription_path(@subscription), notice: 'Coupon has been successfully applied.'
    else
      redirect_to subscription_path(@subscription), alert: 'Invalid coupon or it has reached its maximum uses.'
    end
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
