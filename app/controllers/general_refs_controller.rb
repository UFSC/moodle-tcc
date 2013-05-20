class GeneralRefsController < ApplicationController
  inherit_resources

  before_filter :authorize, :load_tcc

  def index
    @general_refs = @tcc.general_refs
  end

  def create
    @general_ref = GeneralRef.new(params[:general_ref])

    if @general_ref.valid?
      @tcc.transaction do
        @general_ref.save!
        @tcc.references.create!(:element => @general_ref)
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
    @general_ref = GeneralRef.find(params[:id])
    if @general_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:success] = t(:successfully_deleted)
    end
    redirect_to bibliographies_path
  end

  def show
    @general_ref = @tcc.general_refs.find(params[:id])

    if @general_ref.nil?
      flash[:error] = t(:could_not_find)
      nil
    else
      @general_ref
    end
  end

  private

  def authorize
    set_tab :bibliographies

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
