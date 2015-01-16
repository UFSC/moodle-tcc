class CreateBatchPrints < ActiveRecord::Migration
  def change
    create_table :batch_prints do |t|
      t.integer :moodle_id
      t.integer :tcc_id
      t.boolean :must_print

      t.timestamps
    end
    add_index :batch_prints, [:moodle_id, :tcc_id] , unique: true
  end
end
