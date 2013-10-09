class AddActivityUrlToTccDefinition < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :activity_url, :string
  end
end
