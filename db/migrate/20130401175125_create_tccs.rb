class CreateTccs < ActiveRecord::Migration
  def change
    create_table :tccs do |t|
      t.string :title
      t.date :defense_date
      t.references :orientador
      t.references :student
      t.references :tutor

      t.timestamps
    end
  end
end
