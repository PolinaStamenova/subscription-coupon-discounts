# frozen_string_literal: true

class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :percentage
      t.integer :max_uses
      t.integer :used_count, default: 0

      t.timestamps
    end
  end
end
