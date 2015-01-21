class PDFService

  def initialize(moodle_id)
    student = Person.find_by_moodle_id(moodle_id)
    @tcc = Tcc.find_by_student_id (student.id)
  end

  def tcc
    @tcc
  end

  def generate_tex
    # create an instance of ActionView, so we can use the render method outside of a controller
    av = ActionView::Base.new()
    av.view_paths = ActionController::Base.view_paths

    # need these in case your view constructs any links or references any helper methods.
    av.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    # Tcc
    tcc_document = LatexTccDecorator.new(@tcc)

    # Resumo
    abstract = LatexAbstractDecorator.new(@tcc.abstract)

    # Capítulos
    chapters = LatexChapterDecorator.decorate_collection(@tcc.chapters)

    # Referencias
    bibtex = generete_references(av, @tcc)

    pdfTex = av.render pdf: "TCC ##{ @tcc.id }",
                       file: "#{ Rails.root }/app/views/tccs/generate.pdf.erb",
                       locals: { tcc_document: tcc_document,
                                 abstract: abstract,
                                 chapters: chapters,
                                 bibtex: bibtex
                       }

    # File.open(filename(@tcc.student.name,'tex'), 'w+') do |f|
    #   f.write(pdfTex)
    # end

    pdfTex
  end

  def generate_pdf
    pdfTex = generate_tex
    latex_config={:command => 'latex',:parse_twice => true}
    pdf = LatexToPdf.generate_pdf(pdfTex, latex_config)

    # File.open(filename(@tcc.student.name, 'pdf'), "w") do |f|
    #   f.write(result)
    # end

    pdf
  end

  def generete_bibtex(actionview, tcc)
    content = actionview.render :file => "#{ Rails.root }/app/views/tccs/_bibtex.erb",
                                :layout => false,
                                locals: { book_refs: tcc.book_refs.decorate,
                                          book_cap_refs: tcc.book_cap_refs.decorate,
                                          article_refs: tcc.article_refs.decorate,
                                          internet_refs: tcc.internet_refs.decorate,
                                          legislative_refs: tcc.legislative_refs.decorate,
                                          thesis_refs: tcc.thesis_refs.decorate
                                }
    content
  end

  def generete_references(actionview, tcc)
    content = generete_bibtex(actionview, tcc)
    bibtex = TccDocument::ReferencesProcessor.new.execute(content)
    bibtex
  end

end