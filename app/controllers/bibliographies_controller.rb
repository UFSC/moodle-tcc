# encoding: utf-8
class BibliographiesController < ApplicationController

  def index
    set_tab :bibliographies

    @references = @tcc.references.includes(:element).collect { |r| r.element }
    @general_refs = @tcc.general_refs
    @book_refs = @tcc.book_refs
    @book_cap_refs = @tcc.book_cap_refs
    @article_refs = @tcc.article_refs
    @internet_refs = @tcc.internet_refs
    @legislative_refs = @tcc.legislative_refs
    @thesis_refs = @tcc.thesis_refs
    @compound_names = CompoundName.search(params[:search], params[:page], { per: 60 })

  end
end
