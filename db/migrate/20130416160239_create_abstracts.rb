class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.text :content_pt
      t.text :content_en
      t.string :key_words_pt
      t.string :key_words_en
      t.text :commentary
      t.references :tcc

      t.timestamps
    end
    add_index :abstracts, :tcc_id
  end
end
