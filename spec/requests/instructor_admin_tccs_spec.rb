require 'spec_helper'

describe 'InstructorAdminTccs' do
  describe 'GET /instructor_admin_tccs' do
    it 'should work with moodle' do
      page.set_rack_session(fake_lti_session)
      visit instructor_admin_tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de TCCs')
    end

    it 'should not work without moodle' do
      visit instructor_admin_tccs_path
      page.current_path.should == access_denied_path
    end
  end
end
