# encoding: utf-8
Fabricator(:book_ref) do
  first_author    { Faker::Name.name }
  et_all          false
  title           { Faker::Lorem.sentence(4) }
  edition_number  1
  local           { Faker::Address.city }
  publisher       { Faker::Company.name }
  year            1990
end

Fabricator(:book_ref_full, from: :book_ref) do
  first_author    { Faker::Name.name }
  second_author   { Faker::Name.name }
  third_author    { Faker::Name.name }
  et_all          false
  title           { Faker::Lorem.sentence(4) }
  subtitle        { Faker::Lorem.sentence(4) }
  edition_number  1
  local           { Faker::Address.city }
  publisher       { Faker::Company.name }
  year            1990
  type_quantity   { BookRef::QUANTITY_TYPES.sample }
  num_quantity    { 1..250.sample }
end
