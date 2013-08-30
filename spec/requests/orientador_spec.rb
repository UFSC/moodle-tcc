#encoding: utf-8
require 'spec_helper'

describe 'Orientador' do
  describe 'GET /orientador' do
    it 'should work with moodle and tcc type' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/orientador', 'tcc'))
      visit orientador_index_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de TCCs')
    end

    it 'should not work without moodle' do
      visit orientador_index_path
      page.current_path.should == access_denied_path
    end
  end
end
