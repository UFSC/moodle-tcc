Fabricator(:abstract, :class_name => :abstract) do
  content { Faker::Lorem.paragraph(20) }
  keywords { Faker::Lorem.words(10).join(' ') }
end

Fabricator(:abstract_with_comment, :from => :abstract) do
  comment { Fabricate.build(:comment) }
end