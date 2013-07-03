#encoding: utf-8
require 'spec_helper'

describe 'Lti' do
  describe '/' do
    it 'should fail with a 403 if no params were informed' do
      get root_path
      response.status.should be(403)
    end

    it 'should accept a valid LTI consumer request' do
      post root_path, moodle_lti_params
      response.status.should be(302)
    end

    context 'when is a portfolio session' do
      it 'should redirect a student to first hub position' do
        post root_path, moodle_lti_params('student')
        response.status.should be(302)
        response.should redirect_to(show_hubs_path(position: '1'))
      end

      it 'should redirect a instructor to instructor admin screen' do
        post root_path, moodle_lti_params('instructor')
        response.status.should be(302)
        response.should redirect_to(instructor_admin_tccs_path)
      end
    end

    context 'when is a tcc session' do
      it 'should redirect a student to tcc screen' do
        post root_path, moodle_lti_params('student', 'tcc')
        response.status.should be(302)
        response.should redirect_to(show_tcc_path)
      end

      it 'should redirect a instructor to instructor admin screen' do
        post root_path, moodle_lti_params('instructor', 'tcc')
        response.status.should be(302)
        response.should redirect_to(instructor_admin_tccs_path)
      end
    end
  end
end