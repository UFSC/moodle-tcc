class AddEtAlFieldsToBookCapRef < ActiveRecord::Migration
  def change
    add_column :book_cap_refs, :et_al_part, :boolean
    add_column :book_cap_refs, :et_al_entire, :boolean
  end
end
