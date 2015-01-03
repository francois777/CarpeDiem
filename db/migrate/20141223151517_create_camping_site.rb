class CreateCampingSite < ActiveRecord::Migration
  def change
    create_table :camping_sites do |t|
      t.string :location_code
      t.string :type
      t.boolean :powered, default: false
      t.boolean :reservable, default: false
    end
    add_index "camping_sites", [:location_code], name: "index_camping_sites_on_location_code", unique: true
  end
end
