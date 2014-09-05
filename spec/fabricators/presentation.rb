Fabricator(:presentation, :class_name => :presentation) do
  content { Faker::Lorem.paragraph(20) }
end