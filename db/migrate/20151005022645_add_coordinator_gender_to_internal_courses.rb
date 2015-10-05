class AddCoordinatorGenderToInternalCourses < ActiveRecord::Migration
  def change
    add_column :internal_courses, :coordinator_gender, 'char(1)', :after => :coordinator_name
  end
end
