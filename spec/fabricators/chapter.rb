#encoding: utf-8
Fabricator(:chapter) do
  position 1
  content { Faker::Lorem.paragraph(20) }
end