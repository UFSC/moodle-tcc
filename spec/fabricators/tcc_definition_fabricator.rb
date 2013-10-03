Fabricator(:tcc_definition) do
  title { Faker::Lorem.sentence(3) }
  activity_url 'www.example.com'
end
