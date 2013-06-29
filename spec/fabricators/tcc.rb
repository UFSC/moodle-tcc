#encoding: utf-8
Fabricator(:tcc) do
  moodle_user { Fabricate.sequence(:moodle_user) }
  title { Faker::Lorem.words(3) }

  name { Faker::Name.name }
  leader { Faker::Name.name }
  grade 0.9
  defense_date Date.new
  hubs(count: 3)
  presentation
  abstract
  final_considerations
end

Fabricator(:tcc_without_hubs, class_name: :tcc) do

  moodle_user { Fabricate.sequence(:moodle_user) }
  title { Faker::Lorem.words(3) }

  name { Faker::Name.name }
  leader { Faker::Name.name }
  grade 0.9
  defense_date Date.new

  presentation
  abstract
  final_considerations
end
