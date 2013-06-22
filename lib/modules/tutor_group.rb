module TutorGroup
  def self.get_tutor_group(mat)
    Middleware::PessoasGruposTutoria.find_by_matricula(mat).grupo
  end

  def self.get_tutor_group_name(g)
    Middleware::GrupoTutoria.find_by_id(g).nome
  end
end