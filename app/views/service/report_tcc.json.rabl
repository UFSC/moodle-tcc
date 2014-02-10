collection @tccs
attributes :moodle_user => :user_id
attributes :grade, :grade_updated_at
child(:hubs_tccs => 'hubs_tcc') {
  attributes :grade, :grade_date, :state, :position
  attributes :updated_at => :state_date
}
child(:abstract) {
  attributes :content, :key_words, :comentary, :created_at, :update_at, :state
}

child(:presentation) {
  attributes :content, :comentary, :created_at, :update_at, :state
}

child(:final_considerations) {
  attributes :content, :comentary, :created_at, :update_at, :state
}