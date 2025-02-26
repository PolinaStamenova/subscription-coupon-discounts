# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    title { 'Basic' }
    unit_price { 10_000 }
  end
end
