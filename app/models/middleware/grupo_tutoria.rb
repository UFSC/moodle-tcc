class Middleware::GrupoTutoria < ActiveRecord::Base
  self.table_name='GruposTutoria'
  establish_connection :middleware
end