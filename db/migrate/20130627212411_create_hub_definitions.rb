class CreateHubDefinitions < ActiveRecord::Migration
  def change
    create_table :hub_definitions do |t|
      t.references :tcc_definition
      t.string :title
      t.integer :order

      t.timestamps
    end
    add_index :hub_definitions, :tcc_definition_id
  end
end