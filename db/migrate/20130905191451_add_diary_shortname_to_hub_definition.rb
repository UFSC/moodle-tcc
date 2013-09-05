class AddDiaryShortnameToHubDefinition < ActiveRecord::Migration
  def change
    add_column :hub_definitions, :diary_shortname, :string
  end
end
