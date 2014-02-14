Fabricator(:internet_ref) do
  first_author      { Faker::Name.name }
  second_author      { Faker::Name.name }
  third_author      { Faker::Name.name }
  title       { Faker::Lorem.sentence(4) }
  subtitle    { Faker::Lorem.sentence(4) }
  url         { Faker::Internet.url }
  et_al       false
  access_date '2013-05-27'
  publication_date '2013-05-27'
end
