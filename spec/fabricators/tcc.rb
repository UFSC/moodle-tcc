#encoding: utf-8
Fabricator(:tcc, class_name: :tcc) do
  moodle_user 123
  title "um tccs qualquer"

  name "João Fulano"
  leader "João Orientador"
  grade 0.9
  defense_date Date.new
  hubs(count: 3)
  bibliography
  presentation
  abstract
  final_considerations
end


