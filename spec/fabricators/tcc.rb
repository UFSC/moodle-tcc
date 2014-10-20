#encoding: utf-8
Fabricator(:tcc_without_dependencies, :class_name => :tcc) do
  title { Faker::Lorem.sentence(3) }
  student { Fabricate(:person) }

  defense_date { Date.today }
end

Fabricator(:tcc_without_dependencies_memory, :class_name => :tcc) do
  title { Faker::Lorem.sentence(3) }
  student { Fabricate.build(:person) }

  defense_date { Date.today }
end

Fabricator(:tcc, :from => :tcc_without_dependencies, :class_name => :tcc) do
  abstract
  tutor { Fabricate(:person) }
  orientador { Fabricate(:person) }

  chapters(count: 3) { |attrs, i| Fabricate(:chapter, position: i) }
end

Fabricator(:tcc_memory, :from => :tcc_without_dependencies_memory, :class_name => :tcc) do
  abstract
  tutor { Fabricate.build(:person) }
  orientador { Fabricate.build(:person) }

  chapters(count: 3) { |attrs, i| Fabricate.build(:chapter, position: i) }
end

Fabricator(:tcc_with_definitions, :class_name => :tcc, :from => :tcc) do
  tcc_definition
end

# Valid TCC with all Hubs and Diaries and their definitions
Fabricator(:tcc_with_all, :class_name => :tcc, :from => :tcc) do

  # Vamos gerar 3 capítulos
  chapters(count: 3) { |attrs, i| Fabricate(:chapter, position: i) }

  # Após a criação, vamos atribuir o tcc_definition
  after_create do |tcc, transients|
    tcc.tcc_definition = Fabricate(:tcc_definition_with_all)
    tcc.save!
    tcc.reload
  end
end