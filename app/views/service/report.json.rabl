collection @tccs
attributes :moodle_user => :user_id
child(:hubs) {
  attributes :grade, :grade_date, :state, :position
  attributes :updated_at => :state_date
}