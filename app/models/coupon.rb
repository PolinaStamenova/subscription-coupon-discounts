# frozen_string_literal: true

class Coupon < ApplicationRecord
  # Validations
  validates :code, presence: true, uniqueness: true
  validates :percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :max_uses, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_validation :generate_unique_code, on: :create

  private

  def generate_unique_code
    self.code = SecureRandom.uuid[0..7].upcase
  end
end
