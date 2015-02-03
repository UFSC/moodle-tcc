#encoding: utf-8
Fabricator(:tcc_without_dependencies, :class_name => :tcc) do
  title { Faker::Lorem.sentence(3) }
  student { Fabricate(:person) }

  defense_date { Date.today }
end

Fabricator(:tcc, :from => :tcc_without_dependencies, :class_name => :tcc) do
  tutor { Fabricate(:person) }
  abstract
  orientador { Fabricate(:person) }

  chapters(count: 3) { |attrs, i| Fabricate(:chapter, position: i) }
end

Fabricator(:tcc_with_comments, :from => :tcc_without_dependencies, :class_name => :tcc) do
  tutor { Fabricate(:person) }
  abstract { Fabricate(:abstract_with_comment) }
  orientador { Fabricate(:person) }

  chapters(count: 3) { |attrs, i| Fabricate(:chapter_with_comment, position: i) }
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

# Valid TCC with all Hubs and Diaries and their definitions
Fabricator(:tcc_with_all_comments, :class_name => :tcc, :from => :tcc_with_comments) do

  # Após a criação, vamos atribuir o tcc_definition
  after_create do |tcc, transients|
    tcc.tcc_definition = Fabricate(:tcc_definition_with_all)
    tcc.save!
    tcc.reload
  end
end

# Valid TCC with all chapters in done state
Fabricator(:tcc_with_all_done, :class_name => :tcc, :from => :tcc_with_all) do
  # Após a criação, vamos alterar o estados dos capítulos
  after_create do |tcc, transients|
    tcc.abstract.to_done_admin!
    tcc.abstract.save!
    tcc.chapters.each do |chapter|
      chapter.to_done_admin!
      chapter.save!
    end
    tcc.save!
    tcc.reload
  end
end
