class Middleware::OrientadoresAlunos < ActiveRecord::Base
  self.table_name='OrientadoresAlunos'
  establish_connection :middleware

  has_one :pessoa_orientador, class_name: 'Middleware::Pessoas', :primary_key => :matricula_orientador, foreign_key: :matricula
end