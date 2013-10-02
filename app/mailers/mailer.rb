class Mailer < ActionMailer::Base
  default from: "example@email.com"

  def state_altered(email, old_state, new_state)
    @old = old_state
    @new = new_state

    mail(:to => email, :subject => '[UNA-SUS TCC] Estado alterado')
  end


end
