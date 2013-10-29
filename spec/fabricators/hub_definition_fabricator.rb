Fabricator(:hub_definition) do
  position 1
  title { |attrs| "Eixo #{attrs[:position]}" }
  tcc_definition
end

Fabricator(:hub_definition_without_tcc, class_name: :hub_definition) do
  position 1
  title { |attrs| "Eixo #{attrs[:position]}" }
end