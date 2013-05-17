class CreateBookRefs < ActiveRecord::Migration
  def change
    create_table :book_refs do |t|
      t.string :first_author
      t.string :second_author
      t.string :third_author
      t.boolean :et_all
      t.string :title
      t.string :subtitle
      t.integer :edition_number
      t.string :local
      t.string :publisher
      t.integer :year
      t.string :type_quantity
      t.integer :num_quantity
    end
  end
end
