class AddEntireAndPartAuthorsToBookCapRef < ActiveRecord::Migration
  def change
    add_column :book_cap_refs, :second_entire_author, :string
    add_column :book_cap_refs, :third_entire_author, :string
    add_column :book_cap_refs, :second_part_author, :string
    add_column :book_cap_refs, :third_part_author, :string
  end
end
