class AddSubtypeToReferences < ActiveRecord::Migration
  def change
    add_column :article_refs, :subtype, :string
    add_column :book_cap_refs, :subtype, :string
    add_column :book_refs, :subtype, :string
    add_column :internet_refs, :subtype, :string
    add_column :legislative_refs, :subtype, :string
  end
end
