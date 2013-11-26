#encoding: utf-8
Fabricator(:general_ref) do
  direct_citation { Faker::Lorem.sentence(2) }
  indirect_citation { Faker::Lorem.sentence(2) }
  reference_text { Faker::Lorem.sentence(3) }
end

