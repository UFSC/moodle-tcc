class AddShortnameToDiaryDefinition < ActiveRecord::Migration
  def change
    add_column :diary_definitions, :shortname, :string
  end
end
