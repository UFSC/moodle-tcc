# encoding: utf-8
class TccsController < ApplicationController

  def show
    set_tab :tcc_data
    authorize @tcc

    @student = @tcc.student.decorate
  end

  def update
    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to tcc_path(moodle_user: params[:moodle_user])
  end

  def edit_grade

  end

  def evaluate
    authorize(@tcc, :edit_assign_grade?)

    @tcc.grade = params[:tcc][:grade].empty? ? params[:tcc][:grade] : params[:tcc][:grade].to_i
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

  def generate
    render locals: { tcc_document: LatexTccDecorator.new(@tcc),
                     abstract: LatexAbstractDecorator.new(@tcc.abstract),
                     chapters: LatexChapterDecorator.decorate_collection(@tcc.chapters),
                     bibtex: generete_references(@tcc)
           }
  end

  def open_pdf
    batch = BatchTccs.new( @tcc.tcc_definition.pdf_link_hours ) # verificar menor tempo possível
    pdf_file = batch.open_last_pdf_tcc(@tcc)
    if pdf_file.present?
      @pdf = pdf_file.body
      send_data pdf_file.body, disposition: :inline, filename: "generate.pdf", type: :pdf
    else
      redirect_to generate_tcc_path(moodle_user: params[:moodle_user])
    end

  end

  def preview
    @student = @tcc.student.decorate
  end

  protected

  def generete_references (tcc)
    # @book_refs = tcc.book_refs.decorate
    # @book_cap_refs = tcc.book_cap_refs.decorate
    # @article_refs = tcc.article_refs.decorate
    # @internet_refs = tcc.internet_refs.decorate
    # @legislative_refs = tcc.legislative_refs.decorate
    # @thesis_refs = tcc.thesis_refs.decorate

    #criar arquivo
    content = render_to_string(:partial => 'bibtex',
                               :layout => false,
                               locals: { book_refs: tcc.book_refs.decorate,
                                         book_cap_refs: tcc.book_cap_refs.decorate,
                                         article_refs: tcc.article_refs.decorate,
                                         internet_refs: tcc.internet_refs.decorate,
                                         legislative_refs: tcc.legislative_refs.decorate,
                                         thesis_refs: tcc.thesis_refs.decorate

                               }
    )
    @bibtex = TccDocument::ReferencesProcessor.new.execute(content)
  end

end
