Fabricator(:person) do
  name            { Faker::Name.name }
  email           { Faker::Internet.email }
  moodle_username { Faker::Internet.user_name + Fabricate.sequence(:moodle_username).to_s }
  moodle_id       { Fabricate.sequence(:moodle_id) }
end