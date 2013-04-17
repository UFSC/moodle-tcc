class CreateFinalConsiderations < ActiveRecord::Migration
  def change
    create_table :final_considerations do |t|
      t.text :content
      t.text :commentary
      t.references :tcc

      t.timestamps
    end
    add_index :final_considerations, :tcc_id
  end
end
