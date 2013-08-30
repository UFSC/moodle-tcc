#encoding: utf-8
require 'spec_helper'

describe 'Tutor' do
  describe 'GET /tutor' do
    it 'should work with moodle and portfolio type' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/td', 'portfolio'))
      visit orientador_index_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de Portfólios')
    end

    it 'should not work without moodle' do
      visit orientador_index_path
      page.current_path.should == access_denied_path
    end
  end
end