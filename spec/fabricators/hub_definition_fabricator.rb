Fabricator(:hub_definition) do
  title { Faker::Lorem.words(3) }
  order { Fabricate.sequence(:hub_definition) }
  tcc_definition
end