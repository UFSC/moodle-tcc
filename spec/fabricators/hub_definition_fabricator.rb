Fabricator(:hub_definition) do
  title { Faker::Lorem.sentence(3) }
  position 1
  tcc_definition
end

Fabricator(:hub_definition_without_tcc, class_name: :hub_definition) do
  title { Faker::Lorem.sentence(3) }
  position 1
end