Fabricator(:legislative_ref) do
  jurisdiction_or_header { Faker::Lorem.sentence(3) }
  title                  { Faker::Lorem.sentence(4) }
  edition                { 1..10.sample }
  local                  { Faker::Address.city }
  publisher              { Faker::Company.name }
  year                   2003
  total_pages            { 1..250.sample }
end
