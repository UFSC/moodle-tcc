class RemoveTitleFromDiaries < ActiveRecord::Migration
  def self.up
    remove_column :diaries, :title
  end

  def down
  end
end
