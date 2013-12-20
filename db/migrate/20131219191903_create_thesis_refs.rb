class CreateThesisRefs < ActiveRecord::Migration
  def change
    create_table :thesis_refs do |t|
      t.string :author
      t.string :title
      t.string :subtitle
      t.string :local
      t.integer :year
      t.integer :year_of_submission
      t.integer :chapter
      t.string :type_thesis
      t.integer :pages_or_volumes_number
      t.string :type_number
      t.string :degree
      t.string :institution
      t.string :course
      t.string :department
      t.string :subtype
    end
  end
end
