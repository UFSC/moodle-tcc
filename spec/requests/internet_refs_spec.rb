require 'spec_helper'

describe 'InternetRef' do

  let(:attributes) { Fabricate.attributes_for(:internet_ref) }
  let(:internet_ref) { Fabricate(:internet_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates an internet reference with success' do
    it '/new' do
      visit new_internet_ref_path
      fill_in 'Segundo Autor', :with => attributes[:second_author]
      fill_in 'Título', :with => attributes[:title]
      click_button 'Criar Referência da Internet'
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    it '/edit' do
      get edit_book_ref_path(internet_ref.id)
      click_link 'Edit'
      expect(response.status).to be(200)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete internet_ref_path(internet_ref.id)
      expect(response.status).to be(200)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put internet_ref_path(internet_ref.id)
      expect(response.status).to be(200)
    end
  end

end
