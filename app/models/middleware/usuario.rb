class Middleware::Usuario < ActiveRecord::Base
  self.table_name='View_UNASUS2_Usuarios'
  establish_connection :middleware
end