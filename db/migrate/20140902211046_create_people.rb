class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.string :moodle_username
      t.integer :moodle_id

      t.timestamps
    end
  end
end