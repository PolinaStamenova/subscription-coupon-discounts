# frozen_string_literal: true

FactoryBot.define do
  factory :coupon do
    percentage { 10 }
    max_uses { 3 }
  end
end
