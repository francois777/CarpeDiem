class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :organiser_name
      t.string :organiser_telephone
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :confirmed, default: false
      t.integer :estimated_guests_count, default: 0
      t.integer :estimated_chalets_required, default: 0
      t.integer :estimated_sites_required, default: 0
      t.boolean :power_required, default: false
      t.boolean :meals_required, default: false
      t.integer :quoted_cost, default: 0
      t.string :comments, default: ""
    end
  end
end
