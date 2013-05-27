node :urls do
  {:general_ref => 'general_refs/new'}
  {:book_ref => 'book_refs/new'}
  {:book_cap_ref => 'book_cap_refs/new'}
  {:article_ref => 'article_refs/new'}
  {:article_ref => 'internet_refs/new'}
  {:article_ref => 'legislative_refs/new'}
end


child :references do
  child @general_refs do
    extends 'general_refs/index'
  end
  child @book_refs do
    extends 'book_refs/index'
  end
  child @book_cap_refs do
    extends 'book_cap_refs/index'
  end
  child @article_refs do
    extends 'article_refs/index'
  end
  child @internet_refs do
    extends 'internet_refs/index'
  end
  child @legislative_refs do
    extends 'internet_refs/index'
  end
end