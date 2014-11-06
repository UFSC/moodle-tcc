require 'spec_helper'

describe 'ThesisRef' do

  let(:attributes) { Fabricate.attributes_for(:thesis_ref) }
  let(:thesis_ref) { Fabricate(:thesis_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates an internet reference with success' do
    it '/new' do
      visit new_thesis_ref_path
      fill_in 'Autor', :with => attributes[:author]
      fill_in 'Título', :with => attributes[:title]
      click_button 'Criar Referência de Tese ou Monografia'
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    it '/edit' do
      get edit_book_ref_path(thesis_ref.id)
      click_link 'Edit'
      expect(response.status).to be(200)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete thesis_ref_path(thesis_ref.id)
      expect(response.status).to be(200)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put thesis_ref_path(thesis_ref.id)
      expect(response.status).to be(200)
    end
  end

end
