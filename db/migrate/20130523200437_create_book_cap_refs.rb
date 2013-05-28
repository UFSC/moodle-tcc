class CreateBookCapRefs < ActiveRecord::Migration
  def change
    create_table :book_cap_refs do |t|
      t.string :cap_title
      t.string :cap_subtitle
      t.string :book_title
      t.string :book_subtitle
      t.string :cap_author
      t.string :book_author
      t.string :type_participation
      t.string :local
      t.string :publisher
      t.integer :year
      t.integer :initial_page
      t.integer :end_page
    end
  end
end
