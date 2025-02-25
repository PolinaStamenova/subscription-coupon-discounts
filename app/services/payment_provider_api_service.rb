# frozen_string_literal: true

class PaymentProviderApiService
  def initialize(subscription_id)
    @subscription_id = subscription_id
  end

  def update_subscription_unit_price
    subscription = Subscription.find(@subscription_id)

    # Assuming the request is always successful
    {
      success: true,
      status: 200,
      message: "Subscription (ID: #{subscription.id}) unit_price updated successfully."
    }
  end
end
