# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :external_id
      t.references :plan, null: false, foreign_key: true
      t.integer :seats
      t.integer :unit_price

      t.timestamps
    end
  end
end
