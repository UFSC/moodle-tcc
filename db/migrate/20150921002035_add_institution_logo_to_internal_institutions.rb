class AddInstitutionLogoToInternalInstitutions < ActiveRecord::Migration
  # blob
  # def self.up
  #   add_column :internal_institutions, :institution_logo, :binary, :null => false, :size => 1.megabyte, :after => :institution_name
  # end
  #
  # def self.down
  #   remove_column :internal_institutions, :institution_logo
  # end

  def self.up
    add_column :internal_institutions, :data_file_name,     :string,  :null => false, :after => :institution_name
    # add_column :internal_institutions, :data_content_type,  :string,  :after => :data_file_name
    # add_column :internal_institutions, :data_file_size,     :integer, :after => :data_content_type
  end

  def self.down
    remove_column :internal_institutions, :data_file_name
    # remove_column :internal_institutions, :data_content_type
    # remove_column :internal_institutions, :data_file_size
  end
end
