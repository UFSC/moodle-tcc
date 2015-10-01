class InternalCoursesController < ApplicationController
  inherit_resources

  autocomplete :internal_course, :course_name, :full => true

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    @internal_courses = InternalCourse.search(params[:search], params[:page], { per: 7 })
  end

  def new
    @modal_title = t(:add_internal_course)
    @internal_course = InternalCourse.new()
  end

  def create
    @internal_course = InternalCourse.new(params[:internal_course])

    if @internal_course.valid? && @internal_course.save!
      flash[:success] = t(:successfully_saved)
      redirect_to internal_courses_path()
    else
      flash[:error] = t(:please_fix_invalid_data)
      @modal_title = t(:add_internal_institution)
      render :new
    end
  end

  def edit
    @modal_title = t(:edit_internal_course)
    @internal_course = InternalCourse.find(params[:id])
  end

  def update
    @internal_course = InternalCourse.find(params[:id])

    if @internal_course.update_attributes(params[:internal_course])
      flash[:success] = t(:successfully_saved)
      redirect_to internal_courses_path()
    else
      flash[:error] = t(:please_fix_invalid_data)
      @modal_title = t(:edit_internal_course)
      render :edit
    end
  end

  private

  def internal_course_params
    params.require(:internal_course).permit(:course_name, :department_name, :center_name, :coordinator_name, :presentation_data, :approval_data)
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_config?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end
end

