# encoding: utf-8
class TccsController < ApplicationController

  include ActionView::Helpers::SanitizeHelper
  include TccLatex

  def show
    set_tab :data
    @student = @tcc.student.decorate
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
    @tcc = Tcc.find_by_moodle_user(current_moodle_user)

    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to show_tcc_path(moodle_user: params[:moodle_user])
  end

  def show_pdf
    @student = @tcc.student.decorate
    @defense_date = @tcc.defense_date.nil? ? @tcc.defense_date : @tcc.tcc_definition.defense_date

    # Resumo
    @abstract = LatexAbstractDecorator.new(@tcc.abstract)

    # Capítulos
    @chapters = LatexChapterDecorator.decorate_collection(@tcc.chapters.includes([:chapter_definition]).all)

    #Referencias
    @bibtex = generete_references(@tcc)

  end

  def preview_tcc
    @student = @tcc.student.decorate
  end

  protected

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
