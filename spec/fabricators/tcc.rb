#encoding: utf-8
Fabricator(:tccs, class_name: :tccs) do
  moodle_user 123
  title "um tccs qualquer"
  summary "resumo......"
  presentation "apresento isto"
  final_considerations 'considerações finais'
  name "João Fulano"
  leader "João Orientador"
  grade 0.9
  hubs(count: 3)
  bibliography
end

