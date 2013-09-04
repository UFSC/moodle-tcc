module MiddlewareUser
  def self.check_enrol(username, shortname)
    # Carrega a view 'View_UNASUS2_Inscricoes_Cursos' do middleware
    middleware = YAML.load_file("#{Rails.root}/config/database.yml")['middleware']
    Middleware::Unasus2InscricoesCurso.establish_connection middleware

    Middleware::Unasus2InscricoesCurso.where(shortname: shortname).where(username: username).any?
  end
end