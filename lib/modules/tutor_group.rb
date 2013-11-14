# encoding: utf-8
module TutorGroup
  def self.get_tutor_group(mat)
    p = Middleware::PessoasGruposTutoria.find_by_matricula(mat)

    if p.nil?
      nil
    else
      p.grupo
    end
  end

  def self.get_tutor_groups(mat)
    p = Middleware::PessoasGruposTutoria.where(matricula: mat).all
    if p.nil?
      nil
    else
      grupos = Array.new
      p.each do |grupo|
        grupos << grupo.grupo
      end
      grupos
    end
  end

  def self.get_tutor_group_name(g)
    gr = Middleware::GrupoTutoria.find_by_id(g)
    if g.nil?
      'todos os grupos'
    else
      gr.nome
    end
  end

  def self.get_tutor_group_names(g)
    gr = Middleware::GrupoTutoria.where(id: g).all
    if g.nil?
      'todos os grupos'
    else
      gr
    end
  end
end