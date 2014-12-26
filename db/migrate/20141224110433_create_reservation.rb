class CreateReservation < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :reserved_for_name, null: false
      t.datetime :reserved_datetime
      t.string :telephone, default: ""
      t.string :mobile, default: ""
      t.string :email, default: ""
      t.string :town, default: ""
      t.boolean :meals_required, default: false
      t.integer :invoiced_amount, default: 0
      t.boolean :key_deposit_received, default: false
      t.references :reservation_reference
      t.string :vehicle_registration_numbers, default: ""
      t.text :comments
      t.timestamps
    end
    add_index :reservations, :start_date, name: "index_reservations_on_start_date"
    add_index :reservations, :reserved_for_name, name: "index_reservations_on_name"

    create_table :rented_facilities do |t|
      t.references :rentable, polymorphic: true
      t.references :reservation, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :adult_count, default: 0
      t.integer :child_6_12_count, default: 0
      t.integer :child_0_5_count, default: 0
    end
    add_index :rented_facilities, :reservation_id, name: "index_rented_facilities_on_reservation_id"

    create_table :received_payments do |t|
      t.references :reservation, null: false
      t.integer :income_category, default: 0
      t.integer :received_amount, default: 0
      t.integer :payment_method, default: 0
      t.string :receipt_number
      t.timestamps
    end
    add_index :received_payments, :reservation_id, name: "index_received_payments_on_reservation_id"
    add_index :received_payments, :receipt_number, name: "index_received_payments_on_receipt_number"

    create_table :reservation_references do |t|
      t.integer :refid, null: false
      t.integer :reservation_id, null: false
    end
    add_index :reservation_references, :refid, name: "index_reservation_refs_on_refid", unique: true

    create_table :payment_receipts do |t|
      t.integer :received_payment_id, null: false
      t.integer :reservation_id, null: false
    end
    add_index :payment_receipts, :received_payment_id, name: "index_paym_receipts_on_paym_id", unique: true

  end
end
