#encoding: utf-8
Fabricator(:tcc_without_chapters, :class_name => :tcc) do
  title { Faker::Lorem.sentence(3) }

  student { Fabricate(:person) }
  tutor { Fabricate(:person) }
  orientador { Fabricate(:person) }

  defense_date { Date.today }
  presentation
  abstract
  final_considerations
end

Fabricator(:tcc_without_dependencies, :class_name => :tcc) do
  title { Faker::Lorem.sentence(3) }

  student { Fabricate(:person) }
  tutor { Fabricate(:person) }
  orientador { Fabricate(:person) }

  defense_date { Date.today }
end

Fabricator(:tcc, :from => :tcc_without_chapters, :class_name => :tcc) do
  chapters(count: 3) { |attrs, i| Fabricate(:chapter, position: i) }
end

Fabricator(:tcc_with_definitions, :class_name => :tcc, :from => :tcc_without_chapters) do
  tcc_definition
end

# Valid TCC with all Hubs and Diaries and their definitions
Fabricator(:tcc_with_all, :class_name => :tcc, :from => :tcc_without_chapters) do

  # Vamos gerar 3 capítulos
  chapters(count: 3) { |attrs, i| Fabricate(:chapter, position: i) }

  # Após a criação, vamos atribuir o tcc_definition
  after_create do |tcc, transients|
    tcc.tcc_definition = Fabricate(:tcc_definition_with_all)
    tcc.save!
    tcc.reload
  end
end