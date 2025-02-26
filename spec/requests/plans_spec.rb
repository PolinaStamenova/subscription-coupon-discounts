# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  describe 'GET /index' do
    it 'renders a successful response' do
      get plans_path

      expect(response).to be_successful
      expect(response.body).to include('Available Plans')
    end
  end

  describe 'GET /show' do
    let(:plan) { create(:plan) }

    it 'renders a successful response' do
      get plan_path(plan)

      expect(response).to be_successful
      expect(response.body).to include(plan.title.to_s)
    end
  end
end
