class AddDiaryShortnameToHubDefinition < ActiveRecord::Migration
  def change
    add_column :hub_definitions, :moodle_shortname, :string
  end
end
