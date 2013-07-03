class StadarizationOfPositionField < ActiveRecord::Migration
  def change
    rename_column :diaries, :pos, :position
    rename_column :diary_definitions, :order, :position
    rename_column :hubs, :category, :position
    rename_column :hub_definitions, :order, :position
  end
end
