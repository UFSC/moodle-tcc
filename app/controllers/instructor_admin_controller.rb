class InstructorAdminController < ApplicationController
  def index
    @tccs = Tcc.paginate(:page => params[:page], :per_page => 1)
  end
end
