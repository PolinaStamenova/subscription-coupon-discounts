# frozen_string_literal: true

FactoryBot.define do
  factory :subscription_coupon do
    subscription { create(:subscription) }
    coupon { create(:coupon) }
  end
end
