# encoding: utf-8
class BibliographiesController < ApplicationController

  def index
    set_tab :bibliographies

    @references = @tcc.references.includes(:element).collect { |r| r.element }
    @book_refs = @tcc.book_refs.decorate
    @book_cap_refs = @tcc.book_cap_refs.decorate
    @article_refs = @tcc.article_refs.decorate
    @internet_refs = @tcc.internet_refs.decorate
    @legislative_refs = @tcc.legislative_refs.decorate
    @thesis_refs = @tcc.thesis_refs.decorate
    @compound_names = CompoundName.search(params[:search], params[:page], { per: 60 })

  end
end