class CreateReservationRequest < ActiveRecord::Migration
  def change
    create_table :reservation_requests do |t|
      t.string :applicant_name, default: ""
      t.string :applicant_telephone, default: ""
      t.string :applicant_mobile, default: ""
      t.string :applicant_email, default: ""
      t.string :applicant_town, default: ""
      t.integer :facility_type_1, default: 0
      t.datetime :start_date_1
      t.datetime :end_date_1
      t.integer :adults_18_plus_count_1, default: 0
      t.integer :teenagers_count_1, default: 0
      t.integer :children_6_12_count_1, default: 0
      t.integer :infants_count_1, default: 0
      t.boolean :power_point_required_1, default: false
      t.integer :facility_type_2, default: 0
      t.datetime :start_date_2
      t.datetime :end_date_2
      t.integer :adults_18_plus_count_2, default: 0
      t.integer :teenagers_count_2, default: 0
      t.integer :children_6_12_count_2, default: 0
      t.integer :infants_count_2, default: 0
      t.boolean :power_point_required_2, default: false
      t.integer :facility_type_3, default: 0
      t.datetime :start_date_3
      t.datetime :end_date_3
      t.integer :adults_18_plus_count_3, default: 0
      t.integer :teenagers_count_3, default: 0
      t.integer :children_6_12_count_3, default: 0
      t.integer :infants_count_3, default: 0
      t.boolean :power_point_required_3, default: false
      t.integer :meals_required_count, default: 0
      t.string :vehicle_registration_numbers
      t.integer :payable_amount, default: 0
      t.integer :key_deposit_amount, default: 0
      t.datetime :estimated_arrival_time
      t.integer :reservation_reference_id
      t.string :status
      t.text :special_requests, default: ""
      t.timestamps
    end
  end
end
