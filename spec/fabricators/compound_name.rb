Fabricator(:compound_name) do
  name { Faker::Name.name }
  type_name { ['simple', 'suffix'].sample }
end
