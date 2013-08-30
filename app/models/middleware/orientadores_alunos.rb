class Middleware::OrientadoresAlunos < ActiveRecord::Base
  self.table_name='OrientadoresAlunos'
  establish_connection :middleware
end