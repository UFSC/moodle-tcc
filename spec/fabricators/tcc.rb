#encoding: utf-8
Fabricator(:tcc, class_name: :tcc) do
  moodle_user 123
  title "um tcc qualquer"
  summary "resumo......"
  presentation "apresento isto"
  final_considerations 'considerações finais'
  name "João Fulano"
  leader "João Orientador"
  hubs(count: 3)
  bibliography
end

