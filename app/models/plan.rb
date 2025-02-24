# frozen_string_literal: true

class Plan < ApplicationRecord
  # Associations
  has_many :subscriptions

  # Validations
  validates :title, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
