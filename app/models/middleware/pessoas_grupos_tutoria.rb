class Middleware::PessoasGruposTutoria < ActiveRecord::Base
  self.table_name='PessoasGruposTutoria'
  establish_connection :middleware
end