class AddTypeNameToCompoundName < ActiveRecord::Migration
  def change
    add_column :compound_names, :type_name, :string
  end
end
