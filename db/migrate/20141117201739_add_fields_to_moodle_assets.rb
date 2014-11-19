class AddFieldsToMoodleAssets < ActiveRecord::Migration
  def change
    change_table :moodle_assets do |t|
      t.string :remote_filename, :after => :tcc_id, index: true
      t.string :etag, :after => :tcc_id
    end
  end
end
