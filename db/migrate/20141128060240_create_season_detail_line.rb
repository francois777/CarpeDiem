class CreateSeasonDetailLine < ActiveRecord::Migration
  def change
    create_table :season_detail_lines do |t|
      t.integer :season_group_type, default: 0
      t.integer :sequence, default: 0
      t.string :line_col_1, default: ""
      t.string :line_col_2, default: ""
      t.string :line_col_3, default: ""
      t.string :line_col_4, default: ""
    end
  end
end
