class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.text :reflection
      t.integer :category
      t.references :tccs

      t.timestamps
    end
    add_index :hubs, :tcc_id
  end
end
