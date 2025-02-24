# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.string :title
      t.integer :unit_price

      t.timestamps
    end
  end
end
