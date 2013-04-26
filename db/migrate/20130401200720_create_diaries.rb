class CreateDiaries < ActiveRecord::Migration
  def change
    create_table :diaries do |t|
      t.text :content
      t.string :title
      t.references :hub

      t.timestamps
    end
    add_index :diaries, :hub_id
  end
end
