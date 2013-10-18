class Middleware::Orientadores < ActiveRecord::Base
  self.table_name='Orientadores'
  establish_connection :middleware

end