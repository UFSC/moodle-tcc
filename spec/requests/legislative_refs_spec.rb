require 'spec_helper'

describe 'LegislativetRef' do

  let(:attributes) { Fabricate.attributes_for(:legislative_ref) }
  let(:legislative_ref) { Fabricate(:legislative_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates an internet reference with success' do
    it '/new' do
      visit new_legislative_ref_path
      fill_in 'Jurisdição ou Cabeçalho', :with => attributes[:jurisdiction_or_header]
      fill_in 'Título', :with => attributes[:title]
      click_button 'Criar Referência do Legislativo'
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    xit '/edit' do
      visit edit_legislative_ref_path(legislative_ref.id)
      fill_in 'Segundo Autor', :with => attributes[:second_author]
      fill_in 'Título', :with => attributes[:title]
      expect(page).to have_content(:success)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete legislative_ref_path(legislative_ref.id)
      expect(page).to have_content(:successfully_deleted)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put legislative_ref_path(legislative_ref.id)
      expect(page).to have_content(:success)
    end
  end

end
