collection @tccs
attributes :grade, :grade_updated_at

glue (:student) {
  attributes :moodle_id => :user_id
}

child(:abstract) {
  attributes :content, :key_words, :created_at, :update_at, :state, :state_date
}

child(:chapters) {
  attributes :content, :position, :chapter_definition_id, :created_at, :update_at, :state, :state_date
}

