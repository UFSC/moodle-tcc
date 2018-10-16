class AddTccIndexes < ActiveRecord::Migration
  def up
    add_index :tccs, [:orientador_id], name: "index_tcc_on_orientador_id"
    add_index :tccs, [:student_id], name: "index_tcc_on_student_id"
    add_index :tccs, [:tcc_definition_id, :student_id], name: "index_tcc_on_definition_student", unique: true
  end

  def down
    remove_index :tccs, name: "index_tcc_on_orientador_id"
    remove_index :tccs, name: "index_tcc_on_student_id"
    remove_index :tccs, name: "index_tcc_on_definition_student"
  end
end
