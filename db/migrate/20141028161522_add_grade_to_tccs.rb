class AddGradeToTccs < ActiveRecord::Migration
  def change
    add_column :tccs, :grade, :float
    add_column :tccs, :grade_updated_at, :datetime

    add_column :tcc_definitions, :moodle_instance_id, :integer
  end
end
