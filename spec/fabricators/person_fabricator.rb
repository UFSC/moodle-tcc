Fabricator(:person) do
  name            { Faker::Name.name }
  email           { Faker::Internet.email }
  moodle_username { Faker::Lorem.word }
  moodle_id       { (1..1000).to_a.sample }
end