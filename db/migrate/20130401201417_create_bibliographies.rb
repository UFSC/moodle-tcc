class CreateBibliographies < ActiveRecord::Migration
  def change
    create_table :bibliographies do |t|
      t.text :content
      t.references :tcc

      t.timestamps
    end
    add_index :bibliographies, :tcc_id
  end
end
