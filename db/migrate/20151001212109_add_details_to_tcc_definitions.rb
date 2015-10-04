class AddDetailsToTccDefinitions < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :pdf_link_hours, :integer, :after => :minimum_references
    add_column :tcc_definitions, :auto_save_minutes, :integer, :after => :minimum_references
  end
end
