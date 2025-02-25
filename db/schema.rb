# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_250_224_211_859) do # rubocop:disable Metrics/BlockLength
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'coupons', force: :cascade do |t|
    t.string 'code'
    t.integer 'percentage'
    t.integer 'max_uses'
    t.integer 'used_count', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'plans', force: :cascade do |t|
    t.string 'title'
    t.integer 'unit_price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'subscription_coupons', force: :cascade do |t|
    t.bigint 'subscription_id', null: false
    t.bigint 'coupon_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['coupon_id'], name: 'index_subscription_coupons_on_coupon_id'
    t.index ['subscription_id'], name: 'index_subscription_coupons_on_subscription_id'
  end

  create_table 'subscriptions', force: :cascade do |t|
    t.string 'external_id'
    t.bigint 'plan_id', null: false
    t.integer 'seats'
    t.integer 'unit_price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['plan_id'], name: 'index_subscriptions_on_plan_id'
  end

  add_foreign_key 'subscription_coupons', 'coupons'
  add_foreign_key 'subscription_coupons', 'subscriptions'
  add_foreign_key 'subscriptions', 'plans'
end
