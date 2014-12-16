class CreateChalets < ActiveRecord::Migration
  def change
    create_table :chalets do |t|
      t.string :name
      t.string :location_code
      t.integer :style_class
      t.boolean :reservable
      t.datetime :inauguration_date
      t.integer :name_definition
    end
    add_index "chalets", [:location_code], name: "index_chalets_on_location_code", unique: true
  end
end
