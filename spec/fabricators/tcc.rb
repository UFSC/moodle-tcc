#encoding: utf-8
Fabricator(:tcc, :from => :tcc_without_hubs,  :class_name => :tcc) do
  hubs(count: 3) { |attrs, i| Fabricate(:hub, position: i) }
end

Fabricator(:tcc_without_hubs, :class_name => :tcc) do
  moodle_user { Fabricate.sequence(:moodle_user) }
  title { Faker::Lorem.sentence(3) }

  name { Faker::Name.name }
  leader { Faker::Name.name }

  email_orientador { Faker::Internet.email }
  email_estudante { Faker::Internet.email }

  grade (0..100).to_a.sample
  defense_date Date.new
  presentation
  abstract
  final_considerations
end


Fabricator(:tcc_with_definitions, :class_name => :tcc, :from => :tcc_without_hubs) do
  tcc_definition
end