Fabricator(:thesis_ref) do
  author                 { Faker::Name.name }
  title                   { Faker::Lorem.sentence(4) }
  subtitle                { Faker::Lorem.sentence(4) }
  local                   { Faker::Address.city }
  year                    2000
  year_of_submission      2000
  chapter                 1
  type_thesis                    { ThesisRef::THESIS_TYPES.sample }
  pages_or_volumes_number 20
  type_number             { ThesisRef::TYPES.sample }
  degree                  { ThesisRef::DEGREE_TYPES.sample }
  institution             { Faker::Lorem.sentence(4) }
  course                  { Faker::Lorem.sentence(4) }
  department              { Faker::Lorem.sentence(4) }
end
