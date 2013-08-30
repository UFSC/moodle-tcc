module MiddlewareUser
  def self.enrolled(shortname)
    # Carrega a view 'View_UNASUS2_Inscricoes_Cursos' do middleware
    middleware = YAML.load_file("#{Rails.root}/config/database.yml")['middleware']
    Middleware::Unasus2InscricoesCurso.establish_connection middleware

    Middleware::Unasus2InscricoesCurso.where(shortname: shortname)
  end

  def self.check_enrol(enrolled, username)
    enrolled.where(username: username).any?
  end

  #teste
  #def self.test
  #   enrolled = MiddlewareUser::enrolled('SPB110069-21000077ES (20131)')
  #   MiddlewareUser::check_enrol(enrolled, 225695022666)
  #end
end