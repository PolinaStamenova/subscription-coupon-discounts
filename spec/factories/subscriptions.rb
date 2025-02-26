# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    plan { create(:plan) }
    # TODO: Use Faker
    external_id { 'h23p12as34lcld2' }
    seats { 2 }
    unit_price { plan.unit_price }
  end
end
