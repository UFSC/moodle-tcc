class AddSubtypeToLegislativeRef < ActiveRecord::Migration
  def change
    add_column :legislative_ref, :subtype, :string
  end
end
