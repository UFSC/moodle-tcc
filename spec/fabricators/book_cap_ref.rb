Fabricator(:book_cap_ref) do
  cap_title          { Faker::Lorem.sentence(4) }
  cap_subtitle       { Faker::Lorem.sentence(4) }
  book_title         { Faker::Lorem.sentence(4) }
  book_subtitle      { Faker::Lorem.sentence(4) }
  cap_author         { Faker::Name.name }
  book_author        { Faker::Name.name }
  type_participation { BookCapRef::PARTICIPATION_TYPES.sample }
  local              { Faker::Address.city }
  publisher          { Faker::Lorem.sentence(2) }
  year               2000
  initial_page       1
  end_page           10
end
