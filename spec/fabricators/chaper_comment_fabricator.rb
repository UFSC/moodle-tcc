Fabricator(:chapter_comment) do
  comment { Faker::Lorem.paragraph(20) }
end