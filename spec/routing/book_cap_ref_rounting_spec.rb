require 'spec_helper'

describe 'Routes for BookCapRefs' do

  context 'routes /book_cap_refs to the book_cap_ref controller' do
    it 'routes /book_cap_refs to book_cap_refs#index' do
      expect(:get => '/book_cap_refs').to route_to('book_cap_refs#index')
    end

    it 'routes /book_cap_refs to book_cap_refs#create' do
      expect(:post => '/book_cap_refs').to route_to('book_cap_refs#create')
    end

    it 'routes /book_cap_refs/new to book_cap_refs#new' do
      expect(:get => '/book_cap_refs/new').to route_to('book_cap_refs#new')
    end

    it 'routes /book_cap_refs/1/edit to book_cap_refs#edit' do
      expect(:get => '/book_cap_refs/1/edit').to route_to( :controller => 'book_cap_refs',
                                                           :action => 'edit',
                                                           :id => '1')
    end

    it 'routes /book_cap_refs/1/ to book_cap_refs#show' do
      expect(:get => '/book_cap_refs/1').to route_to( :controller => 'book_cap_refs',
                                                      :action => 'show',
                                                      :id => '1')
    end

    it 'routes /book_cap_refs/1 to book_cap_refs#destroy' do
      expect(:delete => '/book_cap_refs/1').to route_to( :controller => 'book_cap_refs',
                                                           :action => 'destroy',
                                                           :id => '1')
    end
    it 'routes /book_cap_refs/1 to book_cap_refs#update' do
      expect(:put => '/book_cap_refs/1').to route_to( :controller => 'book_cap_refs',
                                                         :action => 'update',
                                                         :id => '1')
    end
  end
end
