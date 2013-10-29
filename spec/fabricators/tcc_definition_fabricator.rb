Fabricator(:tcc_definition) do
  title { Faker::Lorem.sentence(3) }
  activity_url { Faker::Internet.url }
end

Fabricator(:tcc_definition_with_all, :class_name => :tcc_definition) do
  title { Faker::Lorem.sentence(3) }
  activity_url { Faker::Internet.url }

  hub_definitions(count: 3) { |attr, i| Fabricate.build(:hub_definition_without_tcc, position: i) }
end