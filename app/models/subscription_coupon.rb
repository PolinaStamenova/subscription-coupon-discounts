# frozen_string_literal: true

class SubscriptionCoupon < ApplicationRecord
  # Assosiations
  belongs_to :subscription
  belongs_to :coupon

  # Callbacks
  after_commit :update_subscription_price, on: :create

  private

  def update_subscription_price
    subscription.update!(unit_price: calculate_discounted_price)

    NotifyPaymentProviderJob.perform_later(subscription.id)
  end

  def calculate_discounted_price
    total_discount = [subscription.coupons.pluck(:percentage).sum, 100].min
    (subscription.plan.unit_price * (1 - total_discount.to_f / 100)).round(2)
  end
end
