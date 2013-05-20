node :urls do
  {:general_ref => 'general_ref/new'}
  {:book_ref => 'book_ref/new'}
end


child :references do
  child @general_refs do
    extends 'general_refs/index'
  end
  child @book_refs do
    extends 'book_refs/index'
  end
end