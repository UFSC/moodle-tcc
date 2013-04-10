class InstructorAdminController < ApplicationController
  def show
    @tccs = Tcc.paginate(:page => params[:page], :per_page => 1)
  end
end
