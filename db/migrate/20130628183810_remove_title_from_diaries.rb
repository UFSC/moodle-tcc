class RemoveTitleFromDiaries < ActiveRecord::Migration
  def self.up
    remove_column :diaries, :title
  end

  def self.down
    add_column :diaries, :title, :string
  end
end
