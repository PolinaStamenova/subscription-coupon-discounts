# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'Associations' do
    it { should belong_to(:plan) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end
end
