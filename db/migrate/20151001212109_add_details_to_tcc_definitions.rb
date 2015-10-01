class AddDetailsToTccDefinitions < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :pdf_link_hours, :integer
    add_column :tcc_definitions, :auto_save_minutes, :integer
  end
end
