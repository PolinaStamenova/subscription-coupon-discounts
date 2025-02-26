# frozen_string_literal: true

class CouponsController < ApplicationController
  before_action :set_coupon, only: %i[show edit update]

  def index
    @coupons = Coupon.all
  end

  def show; end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)

    if @coupon.save
      redirect_to coupon_path(@coupon), notice: 'Coupon was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @coupon.update(coupon_params)
      redirect_to coupon_path(@coupon), notice: 'Coupon was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:percentage, :max_uses)
  end
end
