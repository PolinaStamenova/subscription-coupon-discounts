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
end
