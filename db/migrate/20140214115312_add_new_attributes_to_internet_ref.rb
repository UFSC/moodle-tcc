class AddNewAttributesToInternetRef < ActiveRecord::Migration
  def change
    rename_column :internet_refs, :author, :first_author
    add_column :internet_refs, :second_author, :string
    add_column :internet_refs, :third_author, :string
    add_column :internet_refs, :publication_date, :date
    add_column :internet_refs, :et_al, :boolean
    add_column :internet_refs, :complementary_information, :string
  end
end
