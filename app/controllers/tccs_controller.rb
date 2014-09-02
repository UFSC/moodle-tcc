# encoding: utf-8
class TccsController < ApplicationController

  include ActionView::Helpers::SanitizeHelper
  include TccLatex

  def show
    set_tab :data
    @nome_orientador = Middleware::Orientadores.find_by_cpf(@tcc.orientador).try(:nome) if @tcc.orientador
  end

  def evaluate
    unless current_user.orientador?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      return redirect_user_to_start_page
    end

    @tcc = Tcc.find(params[:tcc_id])
    @tcc.grade = params[:tcc][:grade]

    if @tcc.grade_changed?
      @tcc.grade_updated_at = DateTime.now
    end

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
    @tcc = Tcc.find_by_moodle_user(moodle_user)

    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to show_tcc_path(moodle_user: params[:moodle_user])
  end

  def show_pdf
    eager_load = [{:general_refs => :reference}, {:book_refs => :reference}, {:article_refs => :reference},
                  {:internet_refs => :reference}, {:legislative_refs => :reference}, {:thesis_refs => :reference}]
    @tcc = Tcc.includes(eager_load).find_by_moodle_user(moodle_user)

    @defense_date = @tcc.defense_date.nil? ? @tcc.defense_date : @tcc.tcc_definition.defense_date

    @nome_orientador = Middleware::Orientadores.find_by_cpf(@tcc.orientador).try(:nome) if @tcc.orientador

    #Resumo
    @abstract_content = @tcc.abstract.blank? ? t('empty_abstract') : TccLatex.apply_latex(@tcc, @tcc.abstract.content)
    @abstract_keywords = @tcc.abstract.blank? ? t('empty_abstract') : @tcc.abstract.key_words

    #Introdução
    @presentation = @tcc.presentation.blank? ? t('empty_text') : TccLatex.apply_latex(@tcc, @tcc.presentation.content)

    #Hubs
    @hubs = @tcc.hubs_tccs.includes([:diaries, :hub_definition])
    @hubs.each do |hub|
      hub.fetch_diaries_for_printing(@tcc.moodle_user)
      hub.diaries.map do |diaries|
        diaries.diary_definition.title = TccLatex.cleanup_title(diaries.diary_definition.title)
        diaries.content = TccLatex.apply_latex(@tcc, diaries.content)
      end
      hub.reflection = TccLatex.apply_latex(@tcc, hub.reflection)
      hub.reflection_title = TccLatex.cleanup_title(hub.reflection_title)
    end

    #Consideracoes Finais
    @finalconsiderations = @tcc.final_considerations.blank? ? t('empty_text') : TccLatex.apply_latex(@tcc, @tcc.final_considerations.content)

    #Referencias
    @bibtex = generete_references(@tcc)

  end

  def preview_tcc
    @current_user = current_user
    @matricula = MoodleAPI::MoodleUser.find_username_by_user_id(@tcc.moodle_user)
    @nome_orientador = Middleware::Orientadores.find_by_cpf(@tcc.orientador).try(:nome) if @tcc.orientador

    @abstract = @tcc.abstract
    @presentation = @tcc.presentation
    @hubs = @tcc.hubs_tccs.includes([:diaries, :hub_definition])
    @hubs.each { |hub| hub.fetch_diaries(@user_id) }
    @final_considerations = @tcc.final_considerations
  end

  protected

  def moodle_user
    if current_user.view_all? && params[:moodle_user]
      moodle_user = params[:moodle_user]
    else
      moodle_user = @user_id
    end

    moodle_user
  end

  def generete_references (tcc)
    coder = HTMLEntities.new

    @general_refs = tcc.general_refs
    @general_refs.each do |ref|
      ref.reference_text = coder.decode(ref.reference_text).html_safe
    end

    @book_refs = tcc.book_refs.decorate
    @book_cap_refs = tcc.book_cap_refs.decorate
    @article_refs = tcc.article_refs.decorate
    @internet_refs = tcc.internet_refs.decorate
    @legislative_refs = tcc.legislative_refs.decorate
    @thesis_refs = tcc.thesis_refs.decorate

    #criar arquivo
    content = render_to_string(:partial => 'bibtex', :layout => false)
    @bibtex = TccLatex.generate_references(content)
  end

end
