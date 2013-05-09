class CreateTccs < ActiveRecord::Migration
  def change
    create_table :tccs do |t|
      t.string :moodle_user
      t.string :title
      t.string :name
      t.string :leader
      t.float :grade
      t.date :defense_date
      t.string :state

      t.timestamps
    end
  end
end
