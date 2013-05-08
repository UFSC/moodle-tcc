class InstructorAdminController < ApplicationController
  before_filter :authorize, :only => :index

  def index
    @tccs = Tcc.paginate(:page => params[:page], :per_page => 1)
  end

  private

  def authorize
    if session['lti_launch_params'].nil?
      render file: 'public/500.html'
    end
  end
end
