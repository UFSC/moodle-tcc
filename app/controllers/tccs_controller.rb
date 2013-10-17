# encoding: utf-8
class TccsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include TccLatex

  before_filter :check_permission, :only => :evaluate
  skip_before_filter :authorize, :only => :show_pdf
  skip_before_filter :get_tcc, :only => :show_pdf

  skip_before_filter :authorize, :only => :parse_html
  skip_before_filter :get_tcc, :only => :parse_html

  def show
    set_tab :data
    @nome_orientador = Middleware::Orientadores.find_by_cpf(@tcc.orientador).try(:nome) if @tcc.orientador
  end

  def evaluate
    @tcc = Tcc.find(params[:tcc_id])
    @tcc.grade = params[:tcc][:grade]
    if @tcc.valid?
      @tcc.save!
      flash[:success] = t(:successfully_saved)
      redirect_user_to_start_page
    else
      flash[:error] = t(:unsuccessfully_saved)
      redirect_user_to_start_page
    end
  end

  def save
    if params[:moodle_user]
      @tcc = Tcc.find_by_moodle_user(params[:moodle_user])
    else
      @tcc = Tcc.find_by_moodle_user(@user_id)
    end

    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to show_tcc_path(moodle_user: params[:moodle_user])
  end

  def create_pdf
    @output_dir = '/home/caca/latex'
    @path = params[:path]

    if !@path.nil?
      command = "pdflatex -output-directory=#{@output_dir} -interaction=nonstopmode #{@path}"
      @path = command
      system(command)
    end

  end

  def show_pdf
    @tcc = Tcc.find(313)
    coder = HTMLEntities.new
    tmp = @tcc.abstract.content.gsub('&nbsp;', ' ').gsub('&acute;',%q('))
    @abstract_content = coder.decode(tmp)
    @hubs = @tcc.hubs.hub_tcc
    @final_considerations = @tcc.final_considerations

    #test nokogiri
    @doc = Nokogiri::HTML(@tcc.abstract.content)
  end

  def parse_html
    #Config rails-latex
    LatexToPdf.config[:arguments].delete('-halt-on-error')
    LatexToPdf.config.merge! :parse_twice => true

    #abstract
    coder = HTMLEntities.new
    tcc = Tcc.find(313)
    content = coder.decode(tcc.abstract.content)
    html = Nokogiri::HTML(content)

    # Fazer um xhtml bem formado
    doc = Nokogiri::XML(html.to_xhtml)

    #aplicar xslt
    xh2file = Rails.public_path + '/xh2latex.xsl'
    xslt  = Nokogiri::XSLT(File.read(xh2file))
    transform = xslt.apply_to(doc)

    @tex = transform.gsub('\begin{document}','').gsub('end{document}','')
    #@bibtext = TccLatex::references

    bib = Rails.public_path + '/abntex2-modelo-references'
    @bibtext = bib

  end

  def preview_tcc
    @current_user = current_user
    @matricula = MoodleUser::find_username_by_user_id(@tcc.moodle_user)
    @nome_orientador = Middleware::Orientadores.find_by_cpf(@tcc.orientador).try(:nome) if @tcc.orientador

    @abstract = @tcc.abstract
    @presentation = @tcc.presentation
    @hubs = @tcc.hubs.hub_tcc
    @hubs.each { |hub| hub.fetch_diaries(@user_id) }
    @final_considerations = @tcc.final_considerations
  end

  private
  def check_permission
    unless current_user.orientador?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end
end
