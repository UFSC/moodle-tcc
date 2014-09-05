class AddDefinitions < ActiveRecord::Migration
  def up
    change_table(:tccs) {|t| t.references :tcc_definition }
    change_table(:hubs) {|t| t.references :hub_definition }

    add_index :tccs, :tcc_definition_id
    add_index :hubs, :hub_definition_id
  end

  def down
    remove_column :tccs, :tcc_definition_id
    remove_column :hubs, :hub_definition_id
  end
end