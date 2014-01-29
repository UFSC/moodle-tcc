class RenameBookAndCapAuthorInBookCapRef < ActiveRecord::Migration
  def up
    rename_column :book_cap_refs, :book_author, :first_entire_author
    rename_column :book_cap_refs, :cap_author, :first_part_author
  end

  def down
  end
end
