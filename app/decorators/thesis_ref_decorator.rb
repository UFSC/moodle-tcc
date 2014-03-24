class ThesisRefDecorator < GenericReferenceDecorator
  delegate_all

  def direct_citation
    lastname = citation_author(author)
    "(#{lastname}, #{year})"
  end

  def get_all_authors
    [author]
  end

end