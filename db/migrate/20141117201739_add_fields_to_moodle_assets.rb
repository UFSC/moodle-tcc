class AddFieldsToMoodleAssets < ActiveRecord::Migration
  def change
    add_column :moodle_assets, :remote_id, :string, :after => :tcc_id
    add_column :moodle_assets, :etag, :string, :after => :tcc_id
  end
end
