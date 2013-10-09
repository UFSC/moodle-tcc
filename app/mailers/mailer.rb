class Mailer < ActionMailer::Base
  default from: "example@email.com"

  def state_altered(email, old_state, new_state, url)
    @old = old_state
    @new = new_state
    @url = url

    mail(:to => email, :subject => '[UNA-SUS TCC] Estado alterado')
  end


end
