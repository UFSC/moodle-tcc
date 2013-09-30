class Middleware::UsuariosMatriculasCpfs < ActiveRecord::Base
  self.table_name='UsuariosMatriculasCPFs'
  establish_connection :middleware
end