class Middleware::Pessoas < ActiveRecord::Base
  self.table_name='Pessoas'
  establish_connection :middleware
end