class PrepareTccsToPeople < ActiveRecord::Migration
  def change
    change_table :tccs do |t|
      t.remove :orientador
      t.remove :tutor_group
      t.remove :email_estudante
      t.remove :email_orientador
      t.remove :grade
      t.remove :grade_updated_at
      t.remove :leader
      t.remove :state
      t.remove :moodle_user
      t.references :orientador
      t.references :student
      t.references :tutor
    end
  end
end
