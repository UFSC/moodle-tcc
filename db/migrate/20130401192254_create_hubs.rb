class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.text :reflection, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
      t.integer :position
      t.string :state
      t.float :grade
      t.references :tcc

      t.timestamps
    end
    add_index :hubs, :tcc_id
  end
end
