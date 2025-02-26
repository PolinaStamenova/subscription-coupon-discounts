# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyPaymentProviderJob, type: :job do
  let(:subscription) { create(:subscription) }

  it 'enqueues the job' do
    expect do
      NotifyPaymentProviderJob.perform_later(subscription.id)
    end.to have_enqueued_job(NotifyPaymentProviderJob).with(subscription.id)
  end

  it 'calls PaymentProviderApiService to update subscription price' do
    expect(NotifyPaymentProviderJob.perform_now(subscription.id)).to eq({
                                                                          success: true,
                                                                          status: 200,
                                                                          message: "Subscription (ID: #{subscription.id}) unit_price updated successfully." # rubocop:disable Layout/LineLength
                                                                        })
  end
end
