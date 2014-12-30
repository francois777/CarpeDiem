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

ActiveRecord::Schema.define(version: 20141226101019) do

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

  create_table "camping_sites", force: true do |t|
    t.string  "location_code"
    t.string  "camping_type",  default: "T"
    t.boolean "powered",       default: false
    t.boolean "reservable",    default: false
  end

  add_index "camping_sites", ["location_code"], name: "index_camping_sites_on_location_code", unique: true, using: :btree

  create_table "chalets", force: true do |t|
    t.string   "name"
    t.string   "location_code"
    t.integer  "style_class"
    t.boolean  "reservable"
    t.datetime "inauguration_date"
    t.integer  "name_definition"
  end

  add_index "chalets", ["location_code"], name: "index_chalets_on_location_code", unique: true, using: :btree

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

  create_table "payment_receipts", force: true do |t|
    t.integer "received_payment_id", null: false
    t.integer "reservation_id",      null: false
  end

  add_index "payment_receipts", ["received_payment_id"], name: "index_paym_receipts_on_paym_id", unique: true, using: :btree

  create_table "received_payments", force: true do |t|
    t.integer  "reservation_id",              null: false
    t.integer  "income_category", default: 0
    t.integer  "received_amount", default: 0
    t.integer  "payment_method",  default: 0
    t.string   "receipt_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "received_payments", ["receipt_number"], name: "index_received_payments_on_receipt_number", using: :btree
  add_index "received_payments", ["reservation_id"], name: "index_received_payments_on_reservation_id", using: :btree

  create_table "rented_facilities", force: true do |t|
    t.integer  "rentable_id"
    t.string   "rentable_type"
    t.integer  "reservation_id",               null: false
    t.datetime "start_date",                   null: false
    t.datetime "end_date",                     null: false
    t.integer  "adult_count",      default: 0
    t.integer  "child_6_12_count", default: 0
    t.integer  "child_0_5_count",  default: 0
  end

  add_index "rented_facilities", ["reservation_id"], name: "index_rented_facilities_on_reservation_id", using: :btree

  create_table "reservation_references", force: true do |t|
    t.integer "refid",          null: false
    t.integer "reservation_id", null: false
  end

  add_index "reservation_references", ["refid"], name: "index_reservation_refs_on_refid", unique: true, using: :btree

  create_table "reservation_requests", force: true do |t|
    t.string   "applicant_name",               default: ""
    t.string   "applicant_telephone",          default: ""
    t.string   "applicant_mobile",             default: ""
    t.string   "applicant_email",              default: ""
    t.string   "applicant_town",               default: ""
    t.integer  "facility_type_1",              default: 0
    t.datetime "start_date_1"
    t.datetime "end_date_1"
    t.integer  "adults_18_plus_count_1",       default: 0
    t.integer  "teenagers_count_1",            default: 0
    t.integer  "children_6_12_count_1",        default: 0
    t.integer  "infants_count_1",              default: 0
    t.boolean  "power_point_required_1",       default: false
    t.integer  "facility_type_2",              default: 0
    t.datetime "start_date_2"
    t.datetime "end_date_2"
    t.integer  "adults_18_plus_count_2",       default: 0
    t.integer  "teenagers_count_2",            default: 0
    t.integer  "children_6_12_count_2",        default: 0
    t.integer  "infants_count_2",              default: 0
    t.boolean  "power_point_required_2",       default: false
    t.integer  "facility_type_3",              default: 0
    t.datetime "start_date_3"
    t.datetime "end_date_3"
    t.integer  "adults_18_plus_count_3",       default: 0
    t.integer  "teenagers_count_3",            default: 0
    t.integer  "children_6_12_count_3",        default: 0
    t.integer  "infants_count_3",              default: 0
    t.boolean  "power_point_required_3",       default: false
    t.integer  "meals_required_count",         default: 0
    t.string   "vehicle_registration_numbers"
    t.integer  "payable_amount",               default: 0
    t.integer  "key_deposit_amount",           default: 0
    t.datetime "estimated_arrival_time"
    t.integer  "reservation_reference_id"
    t.text     "special_requests",             default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", force: true do |t|
    t.datetime "start_date",                                   null: false
    t.datetime "end_date",                                     null: false
    t.string   "reserved_for_name",                            null: false
    t.datetime "reserved_datetime"
    t.string   "telephone",                    default: ""
    t.string   "mobile",                       default: ""
    t.string   "email",                        default: ""
    t.string   "town",                         default: ""
    t.boolean  "meals_required",               default: false
    t.integer  "invoiced_amount",              default: 0
    t.boolean  "key_deposit_received",         default: false
    t.integer  "reservation_reference_id"
    t.string   "vehicle_registration_numbers", default: ""
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservations", ["reserved_for_name"], name: "index_reservations_on_name", using: :btree
  add_index "reservations", ["start_date"], name: "index_reservations_on_start_date", using: :btree

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
    t.string   "password_reset_token"
    t.datetime "password_expires_after"
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
