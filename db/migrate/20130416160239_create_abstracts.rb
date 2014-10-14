class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.text :content, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
      t.string :keywords
      t.references :tcc

      t.timestamps
    end
    add_index :abstracts, :tcc_id
  end
end
