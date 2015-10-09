Fabricator(:tcc_definition) do
  activity_url { Faker::Internet.url }
  course_id { Fabricate.sequence(:course_id, 1) }
  defense_date { Faker::Date.forward(30) }
  internal_name { Faker::Lorem.sentence(3) }
  moodle_instance_id { Fabricate.sequence(:moodle_instance_id, 1) }
  internal_course_id { Fabricate.sequence(:internal_course_id) }
  minimum_references {  Faker::Number.between(1, 6) } # >=1
  auto_save_minutes {  Faker::Number.between(0, 3) } # 0 a 10
  pdf_link_hours {  Faker::Number.between(1, 4) }# 1 a 72
end

Fabricator(:tcc_definition_with_all, :class_name => :tcc_definition, :from => :tcc_definition) do
  chapter_definitions(count: 3) { |attr, i| Fabricate.build(:chapter_definition_without_tcc, position: i) }
end