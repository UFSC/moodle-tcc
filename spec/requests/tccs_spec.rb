#encoding: utf-8
require 'spec_helper'

describe "Tccs" do
  describe "GET /tcc" do
    it 'should not work without LTI connection' do
      get show_tcc_path
      response.status.should be(302)
      response.should redirect_to access_denied_path
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session('student', 'tcc'))
      visit show_tcc_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Apresentação')
    end


    describe 'edit' do
      before :each do
        page.set_rack_session(fake_lti_session('student', 'tcc'))
        visit show_tcc_path
      end

      it 'tcc data' do
        click_link 'Dados'
        page.should have_content('Nome')
        page.should have_content('Título')
        page.should have_content('Orientador')

      end

      it 'tcc abstract' do
        click_link 'Resumo'
        page.should have_content('Resumo')
      end

      it 'tcc presentation' do
        click_link 'Apresentação'
        page.should have_content('Apresentação')
      end

      it 'tcc hub 1' do
        click_link 'Eixo 1'
        page.should have_content('Eixo 1')
      end

      xit 'tcc hub 2' do
        click_link 'Eixo 2'
        page.should have_content('Eixo 2')
      end

      xit "tcc hub 3" do
        click_link 'Eixo 3'
        page.should have_content('Eixo 3')
      end

      it 'final consideration' do
        click_link 'Considerações finais'
        page.should have_content('Considerações finais')
      end

      it 'tcc bibliographies' do
        click_link 'Referências'
        page.should have_content('Referências')
      end
    end
  end
end
