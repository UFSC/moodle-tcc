# encoding: utf-8
class TccsController < ApplicationController
  include TccLatex

  def show
    set_tab :data
    @student = @tcc.student.decorate
  end

  def update
    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to tcc_path(moodle_user: params[:moodle_user])
  end

  def generate
    @tcc_document = LatexTccDecorator.new(@tcc)

    # Resumo
    @abstract = LatexAbstractDecorator.new(@tcc.abstract)

    # Capítulos
    @chapters = LatexChapterDecorator.decorate_collection(@tcc.chapters.includes([:chapter_definition]).all)

    # Referencias
    @bibtex = generete_references(@tcc)
  end

  def preview_tcc
    @student = @tcc.student.decorate
  end

  protected

  def generete_references (tcc)
    @book_refs = tcc.book_refs.decorate
    @book_cap_refs = tcc.book_cap_refs.decorate
    @article_refs = tcc.article_refs.decorate
    @internet_refs = tcc.internet_refs.decorate
    @legislative_refs = tcc.legislative_refs.decorate
    @thesis_refs = tcc.thesis_refs.decorate

    #criar arquivo
    content = render_to_string(:partial => 'bibtex', :layout => false)
    @bibtex = TccDocument::ReferencesProcessor.new.execute(content)
  end

end
