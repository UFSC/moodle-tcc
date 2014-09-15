Fabricator(:tcc_definition) do
  title { Faker::Lorem.sentence(3) }
  activity_url { Faker::Internet.url }
  course_id 101
  name 'TCC'
end

Fabricator(:tcc_definition_with_all, :class_name => :tcc_definition) do
  title { Faker::Lorem.sentence(3) }
  activity_url { Faker::Internet.url }
  course_id 101
  name 'TCC'

  chapter_definitions(count: 3) { |attr, i| Fabricate.build(:chapter_definition_without_tcc, position: i) }
end