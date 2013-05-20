class BibliographiesController < ApplicationController
  include LtiTccFilters

  def index
    set_tab :bibliographies

    @references = @tcc.references.collect { |r| r.element }
    @general_refs = @tcc.general_refs
    @book_refs = @tcc.book_refs
  end
end
