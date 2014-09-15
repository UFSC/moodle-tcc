Fabricator(:chapter_definition) do
  position 1
  title { |attrs| "Eixo #{attrs[:position]}" }
  tcc_definition
end

Fabricator(:chapter_definition_without_tcc, class_name: :chapter_definition) do
  position 1
  title { |attrs| "Eixo #{attrs[:position]}" }
end