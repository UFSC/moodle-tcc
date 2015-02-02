Fabricator(:internet_ref) do
  first_author      { Faker::Name.name }
  second_author      { Faker::Name.name }
  third_author      { Faker::Name.name }
  title       { Faker::Lorem.sentence(4) }
  subtitle    { Faker::Lorem.sentence(4) }
  url         { Faker::Internet.url }
  et_al       false
  access_date Date.today
  publication_date Date.today
end
