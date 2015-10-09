class BatchTccsWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :UnASUS, :retry => false

  def filename(filename, extension)
    "tmp/#{filename}.#{extension}"
  end

  def perform(moodle_ids, user_name, user_email, pdf_link_hours)
    begin
      logger.debug('>>> perform: Starting ')
      # batch = BatchTccs.new
      begin
        pdf_link_hours = pdf_link_hours
      rescue
        pdf_link_hours = -1
      end
      batch = BatchTccs.new(pdf_link_hours)
      logger.debug(">>> perform: BatchTccs.new = #{batch} ")
      batch.generate_email(moodle_ids, user_name, user_email)
      logger.debug('>>> perform: Ending ')
      logger.info("+++ E-mail enviado para: <#{user_name}>#{user_email}")
    rescue => e
      logger.error "#{e.message}"
    end
  end
end