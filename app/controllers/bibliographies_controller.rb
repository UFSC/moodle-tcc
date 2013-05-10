
class BibliographiesController < ApplicationController

  def index
    @references = Tcc.first.references.collect { |r| r.element}

    respond_to do |format|
      format.html
      format.json {render :json => @references.to_json}
    end
  end

  def new
  end

  def tcc
    @tcc = Tcc.first
  end

end
