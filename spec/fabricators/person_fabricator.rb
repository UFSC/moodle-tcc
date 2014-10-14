Fabricator(:person) do
  name            { Faker::Name.name }
  email           { Faker::Internet.email }
  moodle_username { Faker::Internet.user_name + Fabricate.sequence(:moodle_username).to_s }
  moodle_id       { (1..1000).to_a.sample }
end