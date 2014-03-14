class ThesisRefDecorator < GenericReferenceDecorator
  delegate_all

  def direct_citation
    lastname = UnicodeUtils.upcase(author.split(' ').last)
    "(#{lastname}, #{year})"
  end

  def get_all_authors
    [author]
  end

end