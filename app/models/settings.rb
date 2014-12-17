# -*- encoding : utf-8 -*-
class Settings < Settingslogic
  source "#{Rails.root}/config/tcc_config.yml"
  namespace Rails.env

  # @return valor do instance_guid que é utilizado para validação de acesso OAUTH com o Moodle
  def instance_guid
    URI.parse(Settings.moodle_url).host
  end

  # @return endereço do serviço de webservice REST do Moodle
  def moodle_rest_url
    url = URI.parse(Settings.moodle_url)
    url.merge!('webservice/rest/server.php').to_s
  end
end