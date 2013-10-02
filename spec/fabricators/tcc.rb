#encoding: utf-8
Fabricator(:tcc) do
  moodle_user { Fabricate.sequence(:moodle_user) }
  title { Faker::Lorem.sentence(3) }

  name { Faker::Name.name }
  leader { Faker::Name.name }

  email_orientador { 'orientador@email.com' }
  email_estudante { 'estudante@email.com' }

  grade 0.9
  defense_date Date.new
  hubs(count: 3) { |attrs, i| Fabricate(:hub, position: i) }
  presentation
  abstract
  final_considerations
end

Fabricator(:tcc_without_hubs, class_name: :tcc) do

  moodle_user { Fabricate.sequence(:moodle_user) }
  title { Faker::Lorem.sentence(3) }

  name { Faker::Name.name }
  leader { Faker::Name.name }
  grade 0.9
  defense_date Date.new

  email_orientador { 'orientador@email.com' }
  email_estudante { 'estudante@email.com' }

  presentation
  abstract
  final_considerations
end
