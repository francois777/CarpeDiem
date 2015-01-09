class AddFacilityCategoryToTariff < ActiveRecord::Migration

  def change
    add_column :tariffs, :facility_category, :integer, default: 0
  end

end
