collection @tccs
attributes :moodle_user => :user_id
attributes :grade, :grade_updated_at
child(:hubs_portfolios => 'hubs') {
  attributes :grade, :grade_date, :state, :position
  attributes :updated_at => :state_date
}