#encoding: utf-8
require 'spec_helper'

describe 'Lti' do

  describe '/' do
    xit 'should fail with a 403 if no params were informed' do
      get root_path
      expect(response.status).to be(403)
    end

    xit 'should accept a valid LTI consumer request' do
      post root_path, moodle_lti_params
      expect(response.status).to be(302)
    end

    context 'when is a tcc session' do
      xit 'should redirect a student to tcc screen' do
        post root_path, moodle_lti_params('student')
        expect(response.status).to be(302)
        expect(response).to redirect_to(tcc_path)
      end

      xit 'should redirect a tutor to access denied screen' do
        post root_path, moodle_lti_params('urn:moodle:role/td')
        expect(response.status).to be(302)
        expect(response).to redirect_to(access_denied_path)
      end

      xit 'should redirect an orientador to access denied' do
        post root_path, moodle_lti_params('urn:moodle:role/orientador')
        expect(response.status).to be(302)
        expect(response).to redirect_to(orientador_index_path)
      end

      xit 'should redirect a coordenador de avea to admin screen' do
        post root_path, moodle_lti_params('urn:moodle:role/coordavea')
        expect(response.status).to be(302)
        expect(response).to redirect_to(instructor_admin_path)
      end

    end
  end
end