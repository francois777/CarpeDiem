# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141211083059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodation_types", force: true do |t|
    t.string  "accom_type"
    t.string  "description",          default: ""
    t.boolean "show",                 default: false
    t.boolean "show_normal_price",    default: false
    t.boolean "show_in_season_price", default: false
    t.boolean "show_promotion",       default: false
  end

  add_index "accommodation_types", ["accom_type"], name: "index_on_accom_type", unique: true, using: :btree

  create_table "diary_days", force: true do |t|
    t.datetime "day"
    t.integer  "diarisable_id"
    t.string   "diarisable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diary_days", ["day"], name: "index_day", using: :btree

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "organiser_name"
    t.string   "organiser_telephone"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "confirmed",                  default: false
    t.boolean  "fully_booked",               default: false
    t.integer  "estimated_guests_count",     default: 0
    t.integer  "estimated_chalets_required", default: 0
    t.integer  "estimated_sites_required",   default: 0
    t.boolean  "power_required",             default: false
    t.boolean  "meals_required",             default: false
    t.integer  "quoted_cost",                default: 0
    t.string   "comments",                   default: ""
  end

  create_table "tariffs", force: true do |t|
    t.string   "tariff_category"
    t.datetime "effective_date"
    t.datetime "end_date"
    t.integer  "tariff"
    t.integer  "accommodation_type_id"
    t.boolean  "with_power_points",     default: false
    t.integer  "price_class",           default: 0
  end

  add_index "tariffs", ["tariff_category", "effective_date"], name: "index_tariffs_cat_effdate", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "admin"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions", using: :btree

end
