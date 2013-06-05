node :general_refs do
  {
      :tab_name => 'Gerais',
      :new_url => '/general_refs/new',
      :collection => partial('general_refs/index', :object => @general_refs)
  }
end
node :book_refs do
  {
      :tab_name => 'Livros',
      :new_url => '/book_refs/new',
      :collection => partial('book_refs/index', :object => @book_refs)
  }
end
node :book_cap_refs do
  {
      :tab_name => 'Capítulos',
      :new_url => '/book_cap_refs/new',
      :collection => partial('book_cap_refs/index', :object => @book_cap_refs)
  }
end
node :article_refs do
  {
      :tab_name => 'Artigos',
      :new_url => '/article_refs/new',
      :collection => partial('article_refs/index', :object => @article_refs)
  }
end
node :internet_refs do
  {
      :tab_name => 'Internet',
      :new_url => '/internet_refs/new',
      :collection => partial('internet_refs/index', :object => @internet_refs)
  }
end
node :legislative_refs do
  {
      :tab_name => 'Legislativo',
      :new_url => '/legislative_refs/new',
      :collection => partial('internet_refs/index', :object => @legislative_refs)
  }
end
