Fabricator(:chapter) do
  position 1
  content { Faker::Lorem.paragraph(20) }
end

Fabricator(:chapter_with_comment, :from => :chapter) do
  chapter_comment { Fabricate.build(:chapter_comment) }
end