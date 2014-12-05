class AddAccommodationTypeId < ActiveRecord::Migration
  def change
    add_column :tariffs, :accommodation_type_id, :integer
  end
end
