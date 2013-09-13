# encoding: utf-8
module OrientadorGroup

  # Retorna o orientador associado a um aluno específico
  # @param [String] matricula matrícula UFSC
  def self.find_orientador_by_matricula_aluno(matricula)
    result = Middleware::OrientadoresAlunos.select(:matricula_orientador).where(matricula_aluno: matricula, ativo: true).first
    result.nil? ? nil : result.matricula_orientador
  end

end