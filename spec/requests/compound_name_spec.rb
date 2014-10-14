#encoding: utf-8
require 'spec_helper'

describe 'CompoundName' do
  describe 'GET /compound_names' do
    it 'should render page with coordavea' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit bibliographies_path(anchor: 'compound_names')

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Nomes compostos')
    end

    xit 'should not work without moodle' do
      visit compound_names_path
      expect(page.current_path).to eq(access_denied_path)
    end

    it 'should work with search term' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit bibliographies_path(anchor: 'compound_names', search: 'São Paulo')

      expect(page).to have_content('Resultado para')
    end
  end
end
