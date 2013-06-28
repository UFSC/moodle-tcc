class AddDefinitions < ActiveRecord::Migration
  def change
    add_column :tccs, :tcc_definition_id, :integer, references: :tcc_definitions
    add_column :hubs, :hub_definition_id, :integer, references: :hub_definitions
    add_column :diaries, :diary_definition_id, :integer, references: :diary_definitions
  end
end
