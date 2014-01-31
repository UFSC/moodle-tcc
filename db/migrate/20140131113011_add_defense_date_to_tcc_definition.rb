class AddDefenseDateToTccDefinition < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :defense_date, :date
  end
end
