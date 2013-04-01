class CreateTccs < ActiveRecord::Migration
  def change
    create_table :tccs do |t|
      t.string :moodle_user
      t.string :title
      t.text :summary
      t.text :presentation
      t.text :final_considerations
      t.string :name
      t.string :leader

      t.timestamps
    end
  end
end
