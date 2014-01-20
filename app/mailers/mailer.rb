# encoding: utf-8
class Mailer < ActionMailer::Base
  default from: -> { Settings.notification_email }

  def state_altered(email, old_state, new_state, url)
    @old = old_state
    @new = new_state
    @url = url

    mail(to: email, subject: '[UNA-SUS TCC] novas alterações no TCC', reply_to: email)
  end

end