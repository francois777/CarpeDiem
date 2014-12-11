class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin
      t.string :password_digest
      t.string :remember_token
      t.timestamps
    end  
    add_index "users", [:email], name: "index_users_on_email", unique: true
    add_index "users", [:remember_token], name: "index_users_on_remember_token"

    create_table :tariffs do |t|
      t.string :tariff_category
      t.datetime :effective_date
      t.datetime :end_date
      t.integer :tariff
      t.integer :accommodation_type_id
      t.boolean :with_power_points, default: false
      t.integer :price_class, default: 0
    end
    add_index :tariffs, [:tariff_category, :effective_date], name: "index_tariffs_cat_effdate", unique: true

    create_table :accommodation_types do |t|
      t.string :accom_type
      t.string :description, default: ""
      t.boolean :show, default: false
      t.boolean :show_normal_price, default: false
      t.boolean :show_in_season_price, default: false
      t.boolean :show_promotion, default: false
    end
    add_index "accommodation_types", [:accom_type], name: "index_on_accom_type", unique: true

    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id], name: "index_versions"

    create_table :events do |t|
      t.string :title
      t.string :organiser_name
      t.string :organiser_telephone
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :confirmed, default: false
      t.boolean :fully_booked, default: false
      t.integer :estimated_guests_count, default: 0
      t.integer :estimated_chalets_required, default: 0
      t.integer :estimated_sites_required, default: 0
      t.boolean :power_required, default: false
      t.boolean :meals_required, default: false
      t.integer :quoted_cost, default: 0
      t.string :comments, default: ""
    end

    create_table :diary_days do |t|
      t.datetime :day
      t.references :diarisable, polymorphic: true
      t.timestamps
    end
    add_index :diary_days, :day, name: "index_day"

  end
end