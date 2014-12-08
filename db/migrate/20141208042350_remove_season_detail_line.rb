class RemoveSeasonDetailLine < ActiveRecord::Migration
  def down
    drop_table :season_details_lines
  end
end
