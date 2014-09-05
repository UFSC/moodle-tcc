#encoding: utf-8
Fabricator(:hub, :class_name => :hub_portfolio) do
  position 1
  reflection { Faker::Lorem.paragraph(20) }
  reflection_title { Faker::Lorem.words(2..10) }
end

Fabricator(:hub_tcc) do
  position 1
  reflection { Faker::Lorem.paragraph(20) }
end