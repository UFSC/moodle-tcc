class AddTccDefinitionsRefToInternalCourses < ActiveRecord::Migration
  def change
    add_reference :tcc_definitions, :internal_course, index: true, :after => :course_id
  end
end
