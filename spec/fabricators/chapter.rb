Fabricator(:chapter) do
  position 1
  content { Faker::Lorem.paragraph(20) }
end

Fabricator(:chapter_with_comment, :from => :chapter) do
  comment { Fabricate.build(:comment) }
end