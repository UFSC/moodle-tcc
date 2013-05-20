class BookRefsController < ApplicationController
  inherit_resources

  before_filter :authorize, :load_tcc

  def index
    @book_refs = @tcc.book_refs
  end

  def create
    @book_ref = BookRef.new(params[:book_ref])

    if @book_ref.valid?
      @tcc.transaction do
        @book_ref.save!
        @tcc.references.create!(:element => @book_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path
      end
    else
      flash[:error] = t(:please_fix_invalid_data)
      render :new
    end
  end

  def update
    update! do |success, failure|
      failure.html do
        flash[:error] = t(:please_fix_invalid_data)
        render :edit
      end
      success.html { redirect_to bibliographies_path, flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @book_ref = BookRef.find(params[:id])
    if @book_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:success] = t(:successfully_deleted)
    end
    redirect_to bibliographies_path
  end

  private

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

  def load_tcc
    set_tab :bibliographies
    @tcc = Tcc.find_by_moodle_user(@user_id)
  end
end
