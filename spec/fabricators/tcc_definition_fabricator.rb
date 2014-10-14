Fabricator(:tcc_definition) do
  activity_url { Faker::Internet.url }
  course_id { Fabricate.sequence(:course_id) }
  defense_date { Faker::Date.forward(30) }
  internal_name { Faker::Lorem.sentence(3) }
end

Fabricator(:tcc_definition_with_all, :class_name => :tcc_definition, :from => :tcc_definition) do
  chapter_definitions(count: 3) { |attr, i| Fabricate.build(:chapter_definition_without_tcc, position: i) }
end