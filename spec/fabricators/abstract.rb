Fabricator(:abstract, :class_name => :abstract) do
  content { Faker::Lorem.paragraph(20) }
  keywords { Faker::Lorem.words(10).join(' ') }
end