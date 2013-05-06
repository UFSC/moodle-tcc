class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :tcc
      t.references :element

      t.timestamps
    end
    add_index :references, :tcc_id
    add_index :references, :element_id
  end
end
