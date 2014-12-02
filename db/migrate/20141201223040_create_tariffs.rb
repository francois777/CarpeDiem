class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.string :tariff_category
      t.integer :tariff
      t.datetime :effective_date
      t.datetime :end_date
    end
  end
end
