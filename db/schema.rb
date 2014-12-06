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

ActiveRecord::Schema.define(version: 20141205235619) do

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

  create_table "season_detail_lines", force: true do |t|
    t.integer "season_group_type", default: 0
    t.integer "sequence",          default: 0
    t.string  "line_col_1",        default: ""
    t.string  "line_col_2",        default: ""
    t.string  "line_col_3",        default: ""
    t.string  "line_col_4",        default: ""
  end

  create_table "tariffs", force: true do |t|
    t.string   "tariff_category"
    t.integer  "tariff"
    t.datetime "effective_date"
    t.datetime "end_date"
    t.integer  "accommodation_type_id"
    t.boolean  "with_power_points",     default: false
    t.integer  "season_class",          default: 0
  end

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

end
