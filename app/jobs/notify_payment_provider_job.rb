# frozen_string_literal: true

class NotifyPaymentProviderJob < ActiveJob::Base
  queue_as :default

  def perform(subscription_id)
    PaymentProviderApiService.new(subscription_id).update_subscription_unit_price
  rescue StandardError => e
    Rails.logger.error("Failed to notify payment provider for Subscription #{subscription_id}: #{e.message}")
  end
end
