class CreateLegislativeRefs < ActiveRecord::Migration
  def change
    create_table :legislative_refs do |t|
      t.string :jurisdiction_or_header
      t.string :title
      t.string :edition
      t.string :local
      t.string :publisher
      t.integer :year
      t.integer :total_pages
    end
  end
end
