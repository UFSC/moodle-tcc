require 'spec_helper'

describe 'BookCapRefs' do

  let(:attributes) { Fabricate.attributes_for(:book_cap_ref) }
  let(:book) { Fabricate(:book_cap_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates a book reference with success' do
    it '/new' do
      visit new_book_cap_ref_path
      fill_in 'Título do Livro', :with => attributes[:book_title]
      fill_in 'Título do Capítulo', :with => attributes[:cap_title]
      click_button 'Criar'
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    it '/edit' do
      visit edit_book_cap_ref_path(book.id)
      fill_in 'Título do Livro', :with => attributes[:book_title]
      fill_in 'Título do Capítulo', :with => attributes[:cap_title]
      expect(page).to have_content(:success)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete book_cap_ref_path(book.id)
      expect(page).to have_content(:successfully_deleted)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put book_cap_ref_path(book.id)
      expect(page).to have_content(:success)
    end
  end

end
