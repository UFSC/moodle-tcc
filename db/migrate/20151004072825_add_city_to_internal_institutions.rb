class AddCityToInternalInstitutions < ActiveRecord::Migration
  def change
    add_column :internal_institutions, :city, :string, :after => :institution_name
  end
end
