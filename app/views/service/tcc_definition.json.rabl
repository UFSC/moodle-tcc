object @tcc_definition
attributes :created_at, :id, :title, :updated_at
child(:hub_definitions) {
  attributes :created_at, :id, :position, :title, :updated_at
  child(:diary_definitions) { attributes :created_at, :external_id, :id, :position, :title, :updated_at }
}

