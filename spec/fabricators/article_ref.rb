Fabricator(:article_ref) do
  first_author       { Faker::Name.name }
  second_author      { Faker::Name.name }
  third_author       { Faker::Name.name }
  et_all             false
  article_title      { Faker::Lorem.sentence(4) }
  article_subtitle   { Faker::Lorem.sentence(4) }
  journal_name       { Faker::Lorem.sentence(4) }
  local              { Faker::Address.city }
  volume_number      1
  number_or_fascicle 1
  publication_date   '2013-05-24'
  initial_page       1
  end_page           20
end
