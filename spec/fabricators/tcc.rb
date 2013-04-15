#encoding: utf-8
Fabricator(:tcc, class_name: :tcc) do
  moodle_user 123
  title "um tccs qualquer"

  abstract "resumo......"
  abstract_commentary "ok"
  abstract_key_words "va, para, outro, lugar"
  english_abstract "abstract......"
  english_abstract_commentary "ok"
  english_abstract_key_words "go, life, borabora"

  presentation "apresento isto"
  presentation_commentary "allalaalal"

  final_considerations 'considerações finais'
  final_considerations_commentary "lalalalala"

  name "João Fulano"
  leader "João Orientador"
  grade 0.9
  year_defense 1999
  hubs(count: 3)
  bibliography
end

