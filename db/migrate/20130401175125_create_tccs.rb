class CreateTccs < ActiveRecord::Migration
  def change
    create_table :tccs do |t|
      t.string :moodle_user
      t.string :title

      t.text :abstract
      t.string :abstract_key_words
      t.text :abstract_commentary

      t.text :english_abstract
      t.string :english_abstract_key_words
      t.text :english_abstract_commentary

      t.text :presentation
      t.text :presentation_commentary

      t.text :final_considerations
      t.text :final_considerations_commentary

      t.string :name
      t.string :leader
      t.float :grade
      t.integer :year_defense

      t.timestamps
    end
  end
end
