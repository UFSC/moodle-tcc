class AddCourseIdToTccDefinition < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :course_id, :string
  end
end
