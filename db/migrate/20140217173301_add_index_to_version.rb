class AddIndexToVersion < ActiveRecord::Migration
  def self.up
    add_index :versions, [:item_id, :item_type, :state]
  end

  def self.down
    remove_index :versions, [:item_id, :item_type, :state]
  end
end
