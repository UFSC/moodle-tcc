class InternalCoursesController < InheritedResources::Base

  private

    def internal_course_params
      params.require(:internal_course).permit(:course_name, :department_name, :center_name, :coordinator_name, :presentation_data, :approval_data)
    end
end

