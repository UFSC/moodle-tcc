class AddNameToTccDefinition < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :name, :string
  end
end
