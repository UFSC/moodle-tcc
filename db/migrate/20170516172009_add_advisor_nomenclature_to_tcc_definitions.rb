class AddAdvisorNomenclatureToTccDefinitions < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :advisor_nomenclature, :string, default: 'orientador', :after => :enabled_sync
  end
end
