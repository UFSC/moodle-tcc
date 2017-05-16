class AddEnabledSyncToTccDefinition < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :enabled_sync, :boolean, default: true, :after => :pdf_link_hours
  end
end
