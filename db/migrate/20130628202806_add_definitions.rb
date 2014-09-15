class AddDefinitions < ActiveRecord::Migration
  def up
    change_table(:tccs) {|t| t.references :tcc_definition }
    change_table(:chapters) {|t| t.references :chapter_definition }

    add_index :tccs, :tcc_definition_id
    add_index :chapters, :chapter_definition_id
  end

  def down
    remove_column :tccs, :tcc_definition_id
    remove_column :chapters, :chapter_definition_id
  end
end