# encoding: utf-8
Fabricator(:book_ref) do
  first_author 'Juca bala'
  et_all false
  title 'Título'
  edition_number 1
  local 'Cidade'
  publisher 'Editora'
  year 1990
end

Fabricator(:book_ref_full, from: :book_ref) do
  first_author { Faker::Name.name }
  second_author { Faker::Name.name }
  third_author { Faker::Name.name }
  et_all false
  title 'Título'
  subtitle 'Subtítulo'
  edition_number 1
  local 'Cidade'
  publisher 'Editora'
  year 1990
  type_quantity 'p'
  num_quantity 235
end
