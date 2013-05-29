class BibliographiesController < ApplicationController
  include LtiTccFilters

  def index
    set_tab :bibliographies

    @references = @tcc.references.collect { |r| r.element }
    @general_refs = @tcc.general_refs
    @book_refs = @tcc.book_refs
    @book_cap_refs = @tcc.book_cap_refs
    @article_refs = @tcc.article_refs
    @internet_refs = @tcc.internet_refs
    @legislative_refs = @tcc.legislative_refs

  end
end
