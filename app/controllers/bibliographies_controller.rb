
class BibliographiesController < ApplicationController

  def index
    @references = Tcc.first.references.collect { |r| r.element}
    @general_refs = Tcc.first.general_refs
  end

  def tcc
    @tcc = Tcc.first
  end

end
