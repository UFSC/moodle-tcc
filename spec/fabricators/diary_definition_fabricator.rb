Fabricator(:diary_definition) do
  title { Faker::Lorem.sentence(3) }
  position 1
  external_id 1234
  hub_definition
end

Fabricator(:diary_definition_without_hub, :class_name => :diary_definition) do
  title { Faker::Lorem.sentence(3) }
  position 1
  external_id 1234
end