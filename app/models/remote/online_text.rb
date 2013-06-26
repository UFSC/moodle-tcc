class Remote::OnlineText < ActiveRecord::Base
  self.table_name =  'assignsubmission_textversion'
  establish_connection :moodle
end