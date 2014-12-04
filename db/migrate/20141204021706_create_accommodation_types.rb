class CreateAccommodationTypes < ActiveRecord::Migration
  def change
    create_table :accommodation_types do |t|
      t.string :accom_type
      t.string :description, default: ""
      t.boolean :show, default: false
      t.boolean :show_normal_price, default: false
      t.boolean :show_in_season_price, default: false
      t.boolean :show_promotion, default: false
    end
  end
end
