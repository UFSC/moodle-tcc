class Test2Worker
  include Sidekiq::Worker
  sidekiq_options :queue => :teste, :retry => false

  def generete_references (actionview, tcc)
    content = actionview.render :file => "#{ Rails.root }/app/views/tccs/_bibtex.erb",
                        :layout => false,
                        locals: { book_refs: tcc.book_refs.decorate,
                                  book_cap_refs: tcc.book_cap_refs.decorate,
                                  article_refs: tcc.article_refs.decorate,
                                  internet_refs: tcc.internet_refs.decorate,
                                  legislative_refs: tcc.legislative_refs.decorate,
                                  thesis_refs: tcc.thesis_refs.decorate
                        }
    @bibtex = TccDocument::ReferencesProcessor.new.execute(content)
  end

  def perform(tcc_id)
    begin
      logger.info "Starting the generation of the TCC: #{tcc_id}"
      @tcc = Tcc.find(tcc_id)
      puts("Start #{@tcc.student.name}")

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
                      # page_height: '3.5in',
                      # page_width: '2in',
                      # margin: {  top: 2,
                      #            bottom: 2,
                      #            left: 3,
                      #            right: 3 },
                      # disposition: 'attachment',
                      # disable_javascript: true,
                      # enable_plugins: false,
                      locals: { tcc_document: tcc_document,
                                abstract: abstract,
                                chapters: chapters,
                                bibtex: bibtex
                      }

      File.open('tmp/test2.tex', 'w+') do |f|
        f.write(pdfTex)
      end

      @latex_config={:command => 'latex',:parse_twice => true}
      result = LatexToPdf.generate_pdf(pdfTex, @latex_config)
      File.open("tmp/test2.pdf", "w") do |f|
        f.write(result)
      end
      puts("End #{@tcc.student.name}")
    end
  end
end