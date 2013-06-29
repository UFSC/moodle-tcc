Fabricator(:hub_definition) do
  title { Faker::Lorem.words(3) }
  order { Fabricate.sequence(:hub_definition) }
  tcc_definition
end

Fabricator(:hub_definition_without_tcc, class_name: :hub_definition) do
  title { Faker::Lorem.words(3) }
  order { Fabricate.sequence(:hub_definition) }
end