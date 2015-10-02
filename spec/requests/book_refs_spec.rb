require 'spec_helper'

describe 'BookRef' do

  let(:attributes) { Fabricate.attributes_for(:book_ref) }
  let(:book_ref) { Fabricate(:book_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates a book reference with success' do
    it '/new' do
      visit new_book_ref_path
      fill_in 'Segundo Autor', :with => attributes[:second_author]
      fill_in 'Título', :with => attributes[:title]
      click_button I18n.t(:'formtastic.actions.create', model: I18n.t(:'activerecord.models.book_ref'))
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    it '/edit' do
      get edit_book_ref_path(book_ref.id)
      click_link 'Edit'
      expect(response.status).to be(200)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete book_ref_path(book_ref.id)
      expect(response.status).to be(200)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put book_ref_path(book_ref.id)
      expect(response.status).to be(200)
    end
  end

end
