class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.text :content, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
      t.integer :position
      t.references :tcc

      t.timestamps
    end
    add_index :chapters, :tcc_id
  end
end
