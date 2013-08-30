module OrientadorGroup
  def self.get_orientador(mat)
    p =  Middleware::OrientadoresAlunos.find_by_matricula_aluno(mat)
    if p.nil? || p.ativo == 0
      nil
    else
      p.matricula_orientador
    end
  end

end