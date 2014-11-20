class AddMultipleAuthorsToThesisRef < ActiveRecord::Migration
  def change
    rename_column :thesis_refs, :author, :first_author
    add_column :thesis_refs, :second_author, :string
    add_column :thesis_refs, :third_author, :string
    add_column :thesis_refs, :et_all, :boolean
  end
end
