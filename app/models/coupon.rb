# frozen_string_literal: true

class Coupon < ApplicationRecord
  # Associations
  has_many :subscription_coupons

  # Validations
  validates :code, presence: true, uniqueness: true
  validates :percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :max_uses, presence: true, numericality: { greater_than: 0 }
  validate :validate_editable, on: :update

  # Callbacks
  before_validation :generate_unique_code, on: :create

  # Scopes
  scope :active, -> { where('used_count < max_uses') }

  # Instance methods
  def invalid?
    used_count >= max_uses
  end

  def apllied?
    return true if subscription_coupons.any?

    false
  end

  private

  def generate_unique_code
    self.code = SecureRandom.uuid[0..7].upcase
  end

  def validate_editable
    return unless apllied?

    errors.add(:base, 'Coupon is already in use and cannot be edited')
  end
end
