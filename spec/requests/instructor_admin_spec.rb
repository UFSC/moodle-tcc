#encoding: utf-8
require 'spec_helper'

describe 'InstructorAdmin' do
  describe 'GET /instructor_admin' do
    it 'should work with moodle' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit instructor_admin_path

      page.current_path.should_not == access_denied_path
    end

    it 'should render tcc listing if starting type is tcc' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea', 'tcc'))
      visit instructor_admin_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de TCCs')
    end

    it 'should render portfolio listing if starting type is portfolio' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea', 'portfolio'))
      visit instructor_admin_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de Portfólios')
    end


    it 'should not work without moodle' do
      visit instructor_admin_path
      page.current_path.should == access_denied_path
    end
  end
end
