class AddSubtypeToBookCapRef < ActiveRecord::Migration
  def change
    add_column :book_cap_ref, :subtype, :string
  end
end
