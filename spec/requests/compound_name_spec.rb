#encoding: utf-8
require 'spec_helper'

describe 'CompoundName' do
  describe 'GET /compound_names' do
    it 'should render page with coordavea' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit bibliographies_path(anchor: 'compound_names')

      page.current_path.should_not == access_denied_path
      page.should have_content('Nomes compostos')
    end

    it 'should not work without moodle' do
      visit compound_names_path
      page.current_path.should == access_denied_path
    end

    it 'should work with search term' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit bibliographies_path(anchor: 'compound_names', search: 'São Paulo')

      page.should have_content('Resultado para')
    end
  end
end
