class AddAttachmentInstitutionLogoToInternalInstitutions < ActiveRecord::Migration
  def self.up
    change_table :internal_institutions do |t|
      t.attachment :institution_logo, :after => :institution_name
    end
  end

  def self.down
    remove_attachment :internal_institutions, :institution_logo
  end
end
