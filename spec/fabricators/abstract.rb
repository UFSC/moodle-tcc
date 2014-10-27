Fabricator(:abstract, :class_name => :abstract) do
  content { Faker::Lorem.paragraph(20) }
  keywords { Faker::Lorem.words(10).join(' ') }
end

Fabricator(:abstract_with_comment, :from => :abstract) do
  chapter_comment { Fabricate.build(:chapter_comment) }
end