class AddCityToInternalInstitutions < ActiveRecord::Migration
  def change
    add_column :internal_institutions, :city, :string, :after => :institution_name
    add_column :internal_institutions, :logo_width, :integer, :after => :institution_name
  end
end
