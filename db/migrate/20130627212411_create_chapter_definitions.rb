class CreateChapterDefinitions < ActiveRecord::Migration
  def change
    create_table :chapter_definitions do |t|
      t.references :tcc_definition
      t.string :title
      t.string :subtitle
      t.integer :position
      t.string :moodle_shortname

      t.timestamps
    end

    add_index :chapter_definitions, :tcc_definition_id
  end
end