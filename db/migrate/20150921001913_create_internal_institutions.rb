class CreateInternalInstitutions < ActiveRecord::Migration
  def change
    create_table :internal_institutions do |t|
      t.string :institution_name

      t.timestamps
    end
  end
end
