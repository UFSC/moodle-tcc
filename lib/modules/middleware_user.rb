# encoding: utf-8
module MiddlewareUser
  def self.check_enrol(username, shortname)
    # TODO: tratar falhas de conexão
    matricula = MoodleAPI::MoodleUser::find_username_by_user_id(username)

    Middleware::InscricoesCurso.where(shortname: shortname).where(username: matricula).any?
  end
end