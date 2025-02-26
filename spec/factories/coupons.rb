# frozen_string_literal: true

FactoryBot.define do
  factory :coupon do
    percentage { 10 }
    max_uses { 3 }
  end

  factory :coupon_with_subscription_coupon, parent: :coupon do
    after(:create) do |coupon|
      create(:subscription_coupon, coupon:, subscription: create(:subscription))
    end
  end
end
