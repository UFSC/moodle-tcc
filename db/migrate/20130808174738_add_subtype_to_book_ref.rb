class AddSubtypeToBookRef < ActiveRecord::Migration
  def change
    add_column :book_ref, :subtype, :string
  end
end
