module ActionMailer
  class Base
    cattr_accessor :smtp_config

    self.smtp_config = YAML::load(File.open("#{Rails.root}/config/smtp.yml"))[Rails.env]

    def self.smtp_settings
      mailer = self.smtp_config[mailer_name]
      @@smtp_settings = mailer.symbolize_keys
    end

  end
end