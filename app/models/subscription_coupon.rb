# frozen_string_literal: true

class SubscriptionCoupon < ApplicationRecord
  # Assosiations
  belongs_to :subscription
  belongs_to :coupon
end
