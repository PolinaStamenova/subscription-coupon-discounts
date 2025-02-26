# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Coupons', type: :request do
  describe 'GET /index' do
    let(:coupon) { create(:coupon) }

    it 'returns http success' do
      get coupons_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Coupons')
    end
  end

  describe 'GET /show' do
    let(:coupon) { create(:coupon) }

    it 'returns http success' do
      get coupon_path(coupon)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_coupon_path

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    context 'with valid parameters' do
      it 'returns http success' do
        expect do
          post coupons_path, params: { coupon: { percentage: 10, max_uses: 100 } }
        end.to change(Coupon, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'with invalid parameters' do
      it 'returns http success' do
        expect do
          post coupons_path, params: { coupon: { percentage: 'ABC', max_uses: 0 } }
        end.to_not change(Coupon, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
