# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show apply_coupon remove_coupon]
  before_action :set_plan, only: %i[index create apply_coupon remove_coupon]

  def index
    @subscriptions = @plan.subscriptions.order(created_at: :desc)
  end

  def show; end

  def create
    # Not clear what the seats number is for, so I am assuming it's 1 for simplicity
    @subscription = @plan.subscriptions.build(seats: 1, unit_price: @plan.unit_price)

    if @subscription.save
      redirect_to plan_subscription_path(@plan, @subscription), notice: 'Subscription has been successfully created.'
    else
      redirect_back(fallback_location: plan_path(@plan),
                    alert: 'An error occurred while creating the subscription. Please try again.')
    end
  end

  def apply_coupon
    if @subscription.apply_coupon(apply_coupon_params[:coupon_code])
      redirect_to plan_subscription_path(@plan, @subscription), notice: 'Coupon has been successfully applied.'
    else
      redirect_to plan_subscription_path(@plan, @subscription),
                  alert: 'Invalid coupon or it has reached its maximum uses.'
    end
  end

  def remove_coupon
    if @subscription.remove_coupon(params[:coupon_id])
      redirect_to plan_subscription_path(@plan, @subscription), alert: 'Coupon has been successfully removed.'
    else
      redirect_to plan_subscription_path(@plan, @subscription),
                  alert: 'Coupon could not be remived. Please try again.'
    end
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def apply_coupon_params
    params.require(:subscription).permit(:coupon_code)
  end
end
