#encoding: utf-8
require 'spec_helper'

describe "Tccs" do
  describe "GET /tccs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tccs_path
      response.status.should be(200)
    end

    it "should work with moodle" do
      #moodle_oauth
      #page.should have_content("Dados")
      pending
    end

    it "should not work without moodle" do
      visit tccs_path
      page.should have_content("wrong")
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
