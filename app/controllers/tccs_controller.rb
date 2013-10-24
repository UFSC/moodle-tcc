# encoding: utf-8
class TccsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include TccLatex

  require 'faker'

  before_filter :check_permission, :only => :evaluate
  before_filter :config_latex, :only => :show_pdf

  #Remover depois
  skip_before_filter :authorize, :only => :show_pdf
  skip_before_filter :authorize, :only => :parse_html
  skip_before_filter :authorize, :only => :show_references

  skip_before_filter :get_tcc, :only => :show_pdf
  skip_before_filter :get_tcc, :only => :parse_html
  skip_before_filter :get_tcc, :only => :show_references

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
    #Selecionar TCC
    @tcc = Tcc.find(313)

    #Resumo
    @abstract_content = @tcc.abstract.blank? ? t('empty_abstract') : TccLatex.apply_latex(@tcc.abstract.content)
    @abstract_keywords = @tcc.abstract.blank? ? t('empty_abstract') : @tcc.abstract.key_words

    #Introdução
    @presentation = @tcc.presentation.blank? ? t('empty_text') : TccLatex.apply_latex(@tcc.presentation.content)

    #Hubs
    @hubs = @tcc.hubs.hub_tcc
    @hubs.each do |hub|
      hub.fetch_diaries(@tcc.moodle_user)
      hub.diaries.map {|diaries| diaries.content = TccLatex.apply_latex(diaries.content)}
      hub.reflection = TccLatex.apply_latex(hub.reflection)
    end

    #Consideracoes Finais
    @finalconsiderations = @tcc.final_considerations.blank? ? t('empty_text') : TccLatex.apply_latex(@tcc.final_considerations.content)

    #Referencias
    @bibtex = generete_references(@tcc)
  end

  def parse_html
    @tcc = Tcc.find(313)

    @references = @tcc.references
    @general_refs = @tcc.general_refs
    @book_refs = @tcc.book_refs
    @book_cap_refs = @tcc.book_cap_refs
    @article_refs = @tcc.article_refs
    @internet_refs = @tcc.internet_refs
    @legislative_refs = @tcc.legislative_refs

    #criar arquivo
    content = render_to_string :show_references, :layout => false
    @content = TccLatex.generate_references(content)
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

  def config_latex
    #Config rails-latex
    LatexToPdf.config[:arguments].delete('-halt-on-error')
    LatexToPdf.config.merge! :parse_twice => true
  end

  def generete_references (tcc)
    @references = tcc.references
    @general_refs = tcc.general_refs
    @book_refs = tcc.book_refs
    @book_cap_refs = tcc.book_cap_refs
    @article_refs = tcc.article_refs
    @internet_refs = tcc.internet_refs
    @legislative_refs = tcc.legislative_refs

    #criar arquivo
    content = render_to_string(:partial => 'bibtex', :layout => false)
    @bibtex = TccLatex.generate_references(content)
  end

end
