class About < ActiveHash::Base

  def About.reset
    self.data = [
        { id: 1,
          name:             'Tcc',
          version:          Version.read_version_hash(7),      # 'Versão (reduzida)'
          version_full:     Version.read_version_hash,          # 'Versão (complea)',
          branch:           Version.get_branch,
          swift_auth_url:   Settings.swift_auth_url,
          docker_image:     Settings.docker_image,
          moodle_url:       Settings.moodle_url,
          moodle_token:     Settings.moodle_token,
          consumer_key:     Settings.consumer_key,
          consumer_secret:  Settings.consumer_secret
        }
    ]
  end
end