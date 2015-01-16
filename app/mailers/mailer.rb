# encoding: utf-8
class Mailer < ActionMailer::Base
  default from: Settings.notification_email

  # transitions from: [:draft, :new], :to => :sent_to_admin_for_evaluation,
  #             on_transition: Proc.new { |obj| obj.send_state_changed_mail(obj.tcc.email_orientador) && obj.clear_commentary! }


  # def send_state_changed_mail(mail_to)
  #   return if self.type != 'HubTcc'
  #
  #   old_state = self.state_was
  #   new_state = self.state
  #   activity_url = self.tcc.tcc_definition.activity_url
  #
  #   Mailer.state_altered(mail_to, old_state, new_state, activity_url).deliver unless mail_to.blank? || mail_to.nil?
  # end


  def state_altered(email, old_state, new_state, url)
    @old = old_state
    @new = new_state
    @url = url

    mail(to: email, subject: '[UNA-SUS TCC] novas alterações no TCC', reply_to: email)
  end

  def tccs_batch_print(name, email, metalink_file, url_tcc)
    @url_tcc = url_tcc

    email_with_name = %("#{name}" <#{email}>)
    attachments["tccs_#{DateTime.now.to_s}.metalink"] = metalink_file
    mail(to: email_with_name,
         subject: '[UNA-SUS TCC] Impressão em lote dos TCCs',
         reply_to: email_with_name)
  end

end