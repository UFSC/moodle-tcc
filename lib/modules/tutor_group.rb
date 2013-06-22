module TutorGroup
  def self.get_tutor_group(mat)
    p =  Middleware::PessoasGruposTutoria.find_by_matricula(mat)
    if p.nil?
      nil
    else
      p.grupo
    end
  end

  def self.get_tutor_group_name(g)
    gr = Middleware::GrupoTutoria.find_by_id(g)
    if g.nil?
      'Todos'
    else
      gr.nome
    end
  end
end