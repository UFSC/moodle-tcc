class Test2Worker
  include Sidekiq::Worker
  sidekiq_options :queue => :teste, :retry => false

  def filename(filename, extension)
    "tmp/#{filename}.#{extension}"
  end

  def perform_old(moodle_id)
    begin
      pdf_service = PDFService.new(moodle_id)
      puts("Starting the TCC print: #{moodle_id} - #{pdf_service.tcc.student.name}")

      # pdfTex = pdf_service.generate_tex
      # File.open(filename(pdf_service.tcc.student.name,'tex'), 'w+') do |f|
      #   f.write(pdfTex)
      # end

      pdf = pdf_service.generate_pdf
      File.open(filename(pdf_service.tcc.student.name, 'pdf'), 'w') do |f|
        f.write(pdf)
      end
      puts("Ending the TCC print: #{moodle_id} - #{pdf_service.tcc.student.name}")
    end
  end

  def perform(moodle_ids, user_name, user_email)
    batch = BatchTccs.new
    batch.generate_email(moodle_ids, user_name, user_email)
  end
end