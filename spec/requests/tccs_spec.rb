#encoding: utf-8
require 'spec_helper'

describe "Tccs" do
  describe "GET /tccs" do
    it 'should not work without LTI connection' do
      get tccs_path
      response.status.should be(302)
      response.should redirect_to access_denied_path
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session)
      visit tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Apresentação')
    end


    describe "edit" do
      before :each do
        #moodle_oauth
      end

      it "tcc data" do
        pending
        #click_link "Dados"
        #page.should have_selector("#data_tab_content")
      end

      it "tcc abstract" do
        pending
        #click_link "Resumo"
        #page.should have_selector("#abstract_tab_content")
      end

      it "tcc presentation" do
        pending
        #click_link "Apresentação"
        #page.should have_selector("#presentation_tab_content")
      end

      it "tcc hub 1" do
        pending
        #click_link "Eixo 1"
        #page.should have_selector("#hub1_tab_content")
      end

      it "tcc hub 2" do
        pending
        #click_link "Eixo 2"
        #page.should have_selector("#hub2_tab_content")
      end

      it "tcc hub 3" do
        pending
        #click_link "Eixo 3"
        #page.should have_selector("#hub3_tab_content")
      end

      it "final consideration" do
        pending
        #click_link "Considerações finais"
        #page.should have_selector("#final_consideration_tab_content")
      end

      it "tcc bibliographies" do
        pending
        #click_link "Referências"
        #page.should have_selector("#bibliographies_tab_content")
      end
    end
  end
end
