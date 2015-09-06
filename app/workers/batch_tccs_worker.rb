class BatchTccsWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :UnASUS, :retry => false

  def filename(filename, extension)
    "tmp/#{filename}.#{extension}"
  end

  def perform(moodle_ids, user_name, user_email)
    begin
      logger.debug('>>> perform: Starting ')
      batch = BatchTccs.new
      logger.debug(">>> perform: BatchTccs.new = #{batch} ")
      batch.generate_email(moodle_ids, user_name, user_email)
      logger.debug('>>> perform: Ending ')
      logger.info("+++ E-mail enviado para: <#{user_name}>#{user_email}")
    rescue => e
      logger.error "#{e.message}"
    end
  end
end