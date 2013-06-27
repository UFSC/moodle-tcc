Fabricator(:diary_definition) do
  title { Faker::Lorem.words(3) }
  order { Fabricate.sequence(:diary_definition) }
  external_id 1234
  hub_definition
end
