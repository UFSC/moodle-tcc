#encoding: utf-8
require 'spec_helper'

describe 'Tccs' do

  describe 'GET /tcc' do
    it 'should not work without LTI connection' do
      get show_tcc_path
      expect(response.status).to be(302)
      expect(response).to redirect_to access_denied_path
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session('student', 'tcc'))
      allow(Middleware::Orientadores).to receive_message_chain(:find_by_cpf, :nome).and_return(Faker::Name.name)
      visit show_tcc_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Introdução')
    end

    describe 'edit' do
      before :each do
        page.set_rack_session(fake_lti_session('student', 'tcc'))
        allow(Middleware::Orientadores).to receive_message_chain(:find_by_cpf, :nome).and_return(Faker::Name.name)
        visit show_tcc_path
      end

      it 'tcc data' do
        click_link 'Dados'
        expect(page).to have_content('Nome')
        expect(page).to have_content('Título')
        expect(page).to have_content('Orientador')
      end

      it 'tcc abstract' do
        click_link 'Resumo'
        expect(page).to have_content('Resumo')
      end

      it 'tcc presentation' do
        click_link 'Introdução'
        expect(page).to have_content('Introdução')
      end

      it 'tcc hub 1' do
        click_link 'Eixo 1'
        expect(page).to have_content('Eixo 1')
      end

      it 'tcc hub 2' do
        click_link 'Eixo 2'
        expect(page).to have_content('Eixo 2')
      end

      it 'tcc hub 3' do
        click_link 'Eixo 3'
        expect(page).to have_content('Eixo 3')
      end

      it 'final consideration' do
        click_link 'Considerações finais'
        expect(page).to have_content('Considerações finais')
      end

      it 'tcc bibliographies' do
        click_link 'Referências'
        expect(page).to have_content('Referências')
      end
    end
  end
end
