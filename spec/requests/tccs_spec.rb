#encoding: utf-8
require 'spec_helper'

describe 'Tccs' do

  let(:attributes) { Fabricate.attributes_for(:tcc) }
  let(:tcc) { Fabricate(:tcc) }

  describe 'GET /tcc' do
    it 'should not work without LTI connection' do
      get tcc_path
      expect(response).to render_template('errors/unauthorized')
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session('student'))
      visit tcc_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content(I18n.t(:data))
    end

    describe 'edit' do
      before :each do
        page.set_rack_session(fake_lti_session('student'))
        visit tcc_path
      end

      it 'tcc data' do
        click_link I18n.t(:data)
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.student'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.title'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.orientador'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.defense_date'))
      end

      it 'tcc abstract' do
        click_link I18n.t(:abstract)
        expect(page).to have_content(I18n.t(:abstract))
      end

      it 'tcc chapter 1' do
        click_link 'Capítulo 1'
        expect(page).to have_content('Capítulo 1')
      end

      it 'tcc chapter 2' do
        click_link 'Capítulo 2'
        expect(page).to have_content('Capítulo 2')
      end

      it 'tcc chapter 3' do
        click_link 'Capítulo 3'
        expect(page).to have_content('Capítulo 3')
      end

      it 'tcc bibliographies' do
        click_link 'Referências'
        expect(page).to have_content('Referências')
      end
    end
  end

  context 'login as student user' do

    before :each do
      page.set_rack_session(fake_lti_session('student'))
    end

    it 'edit and save form with user information' do
      visit '/tcc'
      fill_in 'Título', :with => attributes[:title]
      click_button I18n.t(:save_changes_tcc)
      expect(page).to have_content(:successfully_saved)
    end

    it 'does an edition in the abstract and preview the tcc with that text included' do
      visit edit_abstracts_path
      fill_in 'abstract_content', :with => 'This is my test for abstract!'
      click_button I18n.t(:save_document)
      expect(page).to have_content(I18n.t(:successfully_saved))
      visit preview_tcc_path
      expect(page).to have_content('This is my test for abstract!')
    end

    it 'does an edition in a chapter and preview the tcc with that text included' do
      visit edit_chapters_path(position: 1)
      fill_in 'chapter_content', :with => 'This is my test for chapter 1!'
      click_button I18n.t(:save_document)
      expect(page).to have_content(I18n.t(:successfully_saved))
      visit preview_tcc_path
      expect(page).to have_content('This is my test for chapter 1!')
    end

    it 'do not allow user to edit defense date' do
      visit '/tcc'
      expect(page).to have_field(I18n.t('activerecord.attributes.tcc.defense_date'), :disabled => true)
    end
  end

end
