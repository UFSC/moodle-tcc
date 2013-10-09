node :general_refs do
  {
      :tab_name => 'Gerais',
      :url => 'general_refs',
      :collection => partial('general_refs/index', :object => @general_refs)
  }
end
node :book_refs do
  {
      :tab_name => 'Livros',
      :url => 'book_refs',
      :collection => partial('book_refs/index', :object => @book_refs)
  }
end
node :book_cap_refs do
  {
      :tab_name => 'Capítulos',
      :url => 'book_cap_refs',
      :collection => partial('book_cap_refs/index', :object => @book_cap_refs)
  }
end
node :article_refs do
  {
      :tab_name => 'Artigos',
      :url => 'article_refs',
      :collection => partial('article_refs/index', :object => @article_refs)
  }
end
node :internet_refs do
  {
      :tab_name => 'Internet',
      :url => 'internet_refs',
      :collection => partial('internet_refs/index', :object => @internet_refs)
  }
end
node :legislative_refs do
  {
      :tab_name => 'Legislativo',
      :url => 'legislative_refs',
      :collection => partial('internet_refs/index', :object => @legislative_refs)
  }
end
