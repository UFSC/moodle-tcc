#encoding: utf-8
Fabricator(:tcc_without_hubs, :class_name => :tcc) do
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

Fabricator(:tcc, :from => :tcc_without_hubs, :class_name => :tcc) do
  hubs(count: 3) { |attrs, i| Fabricate(:hub, position: i) }
end

Fabricator(:tcc_with_definitions, :class_name => :tcc, :from => :tcc_without_hubs) do
  tcc_definition
end

# Valid TCC with all Hubs and Diaries and their definitions
Fabricator(:tcc_with_all, :class_name => :tcc, :from => :tcc_without_hubs) do

  # Vamos gerar 3 HubPortfolio e 3 HubTcc:
  hubs(count: 6) do |attrs, i|
    if i < 4
      Fabricate(:hub, position: i)
    else
      Fabricate(:hub_tcc, position: (i%4)+1)
    end
  end

  # Após a criação, vamos atribuir o tcc_definition
  after_create do |tcc, transients|
    tcc.tcc_definition = Fabricate(:tcc_definition_with_all)
    tcc.save!
    tcc.reload
  end
end