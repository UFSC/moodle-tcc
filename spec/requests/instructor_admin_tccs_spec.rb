require 'spec_helper'

describe 'InstructorAdminTccs' do
  describe 'GET /instructor_admin_tccs' do
    xit 'should work with moodle' do
      page.set_rack_session(fake_lti_session)
      visit instructor_admin_tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de TCCs')
    end

    it 'should not work without moodle' do
      visit instructor_admin_tccs_path
      page.current_path.should == access_denied_path
    end

    xit 'should visit admin page' do
      page.set_rack_session(fake_lti_session('instructor','portfolio'))
      visit instructor_admin_tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Tela de Tutor')
    end

    xit 'should visit leader page' do
      page.set_rack_session(fake_lti_session('instructor','tcc'))
      visit instructor_admin_tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Tela de Orientador')
    end

    xit 'should show param error' do
      page.set_rack_session(fake_lti_session('instructor','error param'))
      visit instructor_admin_tccs_path

      page.current_path.should_not == access_denied_path
      page.should have_css('.text-error')
    end
  end
end
