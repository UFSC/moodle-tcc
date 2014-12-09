object @tcc_definition
attributes :created_at, :id, :internal_name, :updated_at
child(:chapter_definitions) {
  attributes :created_at, :id, :position, :title, :updated_at
}

