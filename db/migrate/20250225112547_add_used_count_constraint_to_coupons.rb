# frozen_string_literal: true

class AddUsedCountConstraintToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :coupons, 'used_count <= max_uses', name: 'check_used_count_within_max_uses'
  end
end
