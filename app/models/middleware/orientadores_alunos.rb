class Middleware::OrientadoresAlunos < ActiveRecord::Base
  self.table_name='OrientadoresAlunos'
  establish_connection :middleware

  has_one :usuarios_matriculas_cpfs, class_name: 'Middleware::UsuariosMatriculasCpfs',
          :primary_key => :matricula_orientador, :foreign_key => :matricula

  default_scope where(ativo: true)
end