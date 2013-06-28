class CreateDiaryDefinitions < ActiveRecord::Migration
  def change
    create_table :diary_definitions do |t|
      t.references :hub_definition
      t.integer :external_id
      t.string :title
      t.integer :order

      t.timestamps
    end
    add_index :diary_definitions, :hub_definition_id
  end
end
