class CreateTccDefinitions < ActiveRecord::Migration
  def change
    create_table :tcc_definitions do |t|
      t.string :name
      t.string :title
      t.string :activity_url
      t.integer :course_id
      t.date :defense_date

      t.timestamps
    end
  end
end
