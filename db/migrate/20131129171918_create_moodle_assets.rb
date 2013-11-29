class CreateMoodleAssets < ActiveRecord::Migration
  def change
    create_table :moodle_assets do |t|
      t.string  :data_file_name, :null => false
      t.string  :data_content_type
      t.integer :data_file_size

      t.timestamps
    end
    add_index :moodle_assets, :tcc_id
  end
end
