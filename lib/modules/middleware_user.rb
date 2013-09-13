module MiddlewareUser
  def self.check_enrol(username, shortname)
    matricula = MoodleUser::find_username_by_user_id(username)
    # Carrega a view 'View_UNASUS2_Inscricoes_Cursos' do middleware
    middleware = YAML.load_file("#{Rails.root}/config/database.yml")['middleware']
    Middleware::InscricoesCurso.establish_connection middleware

    Middleware::InscricoesCurso.where(shortname: shortname).where(username: matricula).any?
  end
end