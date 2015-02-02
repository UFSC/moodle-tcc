class BatchTccsWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :UnASUS, :retry => false

  def filename(filename, extension)
    "tmp/#{filename}.#{extension}"
  end

  def perform(moodle_ids, user_name, user_email)
    batch = BatchTccs.new
    batch.generate_email(moodle_ids, user_name, user_email)
  end
end