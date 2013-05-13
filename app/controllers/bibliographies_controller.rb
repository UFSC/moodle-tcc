
class BibliographiesController < ApplicationController

  def index
    @references = Tcc.first.references.collect { |r| r.element}
  end

  def new
  end

  def tcc
    @tcc = Tcc.first
  end

end
