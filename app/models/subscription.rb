# frozen_string_literal: true

class Subscription < ApplicationRecord
  # Associations
  belongs_to :plan

  # Validations
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
