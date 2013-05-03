class CreateGeneralRefs < ActiveRecord::Migration
  def change
    create_table :general_refs do |t|
      t.string :direct_citation
      t.string :indirect_citation
      t.string :reference_text
    end
  end
end
