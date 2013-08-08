class AddSubtypeToInternetRef < ActiveRecord::Migration
  def change
    add_column :internet_ref, :subtype, :string
  end
end
