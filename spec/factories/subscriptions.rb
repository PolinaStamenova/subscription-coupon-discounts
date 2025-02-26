# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    plan { create(:plan) }
    # TODO: Use Faker
    external_id { 'h23p12as34lcld2' }
    seats { 2 }
    unit_price { plan.unit_price }
  end

  factory :subscription_with_coupon, parent: :subscription do
    after(:create) do |subscription|
      create(:subscription_coupon, subscription:, coupon: create(:coupon))
    end
  end
end
