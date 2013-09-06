#encoding: utf-8
Fabricator(:hub, class_name: :hub) do
  position 1
  reflection { Faker::Lorem.paragraph(20) }
  diaries(count: 2)
  grade 8
  commentary { Faker::Lorem.paragraph(10) }
  type 'HubPortfolio'
end