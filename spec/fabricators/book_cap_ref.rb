Fabricator(:book_cap_ref) do
  cap_title { Faker::Lorem.sentence(4) }
  cap_subtitle { Faker::Lorem.sentence(4) }
  book_title { Faker::Lorem.sentence(4) }
  book_subtitle { Faker::Lorem.sentence(4) }
  first_part_author { Faker::Name.name }
  second_part_author { Faker::Name.name }
  third_part_author { Faker::Name.name }
  first_entire_author { Faker::Name.name }
  second_entire_author { Faker::Name.name }
  third_entire_author { Faker::Name.name }
  type_participation { BookCapRef::PARTICIPATION_TYPES.sample }
  local { Faker::Address.city }
  publisher { Faker::Lorem.sentence(2) }
  year 2000
  initial_page 1
  end_page 10
end
