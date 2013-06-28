Fabricator(:hub_definition) do
  title { Faker::Lorem.words(3) }
  order { Fabricate.sequence(:hub_definition) }
  external_id 1234
  tcc_definition
end