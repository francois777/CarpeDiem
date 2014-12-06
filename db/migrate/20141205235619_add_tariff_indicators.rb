class AddTariffIndicators < ActiveRecord::Migration
  def change
    add_column :tariffs, :with_power_points, :boolean, default: false
    add_column :tariffs, :season_class, :integer, default: 0
  end
end
