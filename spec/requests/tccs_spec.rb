#encoding: utf-8
require 'spec_helper'

describe 'Tccs' do

  describe 'GET /tcc' do
    xit 'should not work without LTI connection' do
      get tcc_path
      expect(response.status).to be(302)
      expect(response).to redirect_to access_denied_path
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session('student'))
      visit tcc_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Dados')
    end

    describe 'edit' do
      before :each do
        page.set_rack_session(fake_lti_session('student'))
        visit tcc_path
      end

      it 'tcc data' do
        click_link 'Dados'
        expect(page).to have_content('Estudante')
        expect(page).to have_content('Título')
        expect(page).to have_content('Orientador')
        expect(page).to have_content('Data da defesa')
      end

      it 'tcc abstract' do
        click_link 'Resumo'
        expect(page).to have_content('Resumo')
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

  # context 'login as admin user' do
  #   it '/user/id/tcc' do
  #     visit instructor_admin_path
  #
  #   end
  #
  # end

end
