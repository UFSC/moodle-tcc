class BookRefsController < ApplicationController

  before_filter :authorize


  def new
    @book_ref = BookRef.new
  end

  def index
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @book_refs = @tcc.book_refs
  end

  def show
  end

  def update
  end

  def edit
    @book_ref = BookRef.find(params[:id])
  end

  def create
    @book_ref = BookRef.new(params[:book_ref])
    @book_ref.save
    tcc = Tcc.find_by_moodle_user(@user_id)
    tcc.references.create(:element => @book_ref)
    if tcc.save
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:unsuccessfully_saved)
    end
    redirect_to '/bibliographies'
  end

  def destroy
    @book_ref = BookRef.find(params[:id])
    if @book_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:success] = t(:successfully_deleted)
    end
    redirect_to '/bibliographies'
  end

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'
      redirect_to access_denied_path
    else
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG["consumer_key"], TCC_CONFIG["consumer_secret"], lti_params)
      if @tp.instructor?
        @user_id = params["moodle_user"]
      else
        @user_id = @tp.user_id
      end

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end
end
