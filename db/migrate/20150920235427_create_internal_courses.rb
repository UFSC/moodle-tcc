class CreateInternalCourses < ActiveRecord::Migration
  def change
    create_table :internal_courses do |t|
      t.references :internal_institution
      t.string :course_name
      t.string :department_name
      t.string :center_name
      t.string :coordinator_name
      t.string :presentation_data
      t.string :approval_data

      t.timestamps
    end
  end
end
