class AddSubtitleToHubDefinitions < ActiveRecord::Migration
  def change
    add_column :hub_definitions, :subtitle, :string
  end
end
