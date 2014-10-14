class CreateChapterDefinitions < ActiveRecord::Migration
  def change
    create_table :chapter_definitions do |t|
      t.references :tcc_definition
      t.string :title # Título do capítulo que será utilizado no documento
      t.integer :coursemodule_id # ID (CourseModule) do assign que pode conter uma prévia do conteúdo a ser importado
      t.integer :position # Ordem em que esse capítulos será apresentado e incluído no documento
      t.boolean :is_numbered_title, default: true # Este é um capítulo numerado? (ex: 1. Introdução)

      t.timestamps
    end

    add_index :chapter_definitions, :tcc_definition_id
  end
end