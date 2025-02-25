# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionCoupon, type: :model do
  describe 'Associations' do
    it { should belong_to(:subscription) }
    it { should belong_to(:coupon) }
  end
end
