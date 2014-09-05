class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.text :content, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
      t.references :tcc

      t.timestamps
    end
    add_index :presentations, :tcc_id
  end
end
