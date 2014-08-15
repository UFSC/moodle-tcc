#encoding: utf-8
require 'spec_helper'

describe 'Orientador' do
  describe 'GET /orientador' do
    xit 'should work with moodle and tcc type' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/orientador', 'tcc'))

      visit orientador_index_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Lista de TCCs')
    end

    it 'should not work without moodle' do
      visit orientador_index_path
      expect(page.current_path).to eq(access_denied_path)
    end
  end
end
