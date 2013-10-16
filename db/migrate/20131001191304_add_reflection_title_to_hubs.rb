class AddReflectionTitleToHubs < ActiveRecord::Migration
  def change
    add_column :hubs, :reflection_title, :string
  end
end
