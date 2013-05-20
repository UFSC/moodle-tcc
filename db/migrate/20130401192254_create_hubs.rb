class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.text :reflection
      t.text :commentary
      t.integer :category
      t.string :state
      t.float :grade
      t.references :tcc

      t.timestamps
    end
    add_index :hubs, :tcc_id
  end
end
