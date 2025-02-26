# frozen_string_literal: true

class Subscription < ApplicationRecord
  # Associations
  belongs_to :plan
  has_many :subscription_coupons
  has_many :coupons, through: :subscription_coupons

  # Validations
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def apply_coupon(coupon_id)
    return false if subscription_coupons.exists? # Ensure only one coupon is applied per subscription

    ActiveRecord::Base.transaction do
      coupon = Coupon.active.lock('FOR UPDATE').find_by(id: coupon_id)

      return false if coupon.nil? || coupon.invalid?

      SubscriptionCoupon.create!(subscription: self, coupon:)
      coupon.increment!(:used_count)

      true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    Rails.logger.error("Coupon (ID: #{coupon_id}) application failed: #{e.message}")
    false
  end

  def remove_coupon(coupon_id)
    ActiveRecord::Base.transaction do
      coupon = coupons.lock('FOR UPDATE').find_by(id: coupon_id)

      return false if coupon.nil?

      subscription_coupon = subscription_coupons.find_by(subscription: self, coupon:)

      return false unless subscription_coupon

      process_coupon_removal(subscription_coupon, coupon)
    end

    NotifyPaymentProviderJob.perform_later(id)

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed, ActiveRecord::StatementInvalid => e
    Rails.logger.error("Error removing coupon: #{e.message}")
    false
  end

  private

  def process_coupon_removal(subscription_coupon, coupon)
    subscription_coupon.destroy!
    update!(unit_price: plan.unit_price) # Reset the unit price to the original plan price
    coupon.decrement!(:used_count)
  end
end
