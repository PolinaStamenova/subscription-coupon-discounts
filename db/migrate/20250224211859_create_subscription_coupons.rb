# frozen_string_literal: true

class CreateSubscriptionCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :subscription_coupons do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
