#encoding: utf-8
require 'spec_helper'

describe 'InstructorAdmin' do
  describe 'GET /instructor_admin' do
    it 'should work with moodle' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit instructor_admin_path

      expect(page.current_path).not_to eq(access_denied_path)
    end

    it 'should render tcc listing if starting type is tcc' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/coordavea'))
      visit instructor_admin_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Lista de TCCs')
    end

    it 'should not work without moodle' do
      get instructor_admin_path
      expect(response).to render_template('errors/unauthorized')
    end
  end
end
