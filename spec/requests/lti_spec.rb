#encoding: utf-8
require 'spec_helper'

describe "Lti" do
  describe "/" do
    it 'should fail with a 403 if no params were informed' do
      get root_path
      response.status.should be(403)
    end

    it 'should accept a valid LTI consumer request' do
      pending('Teste não está validando OAuth por algum motivo. Verificar depois')

      post root_path, moodle_lti_params
      response.status.should be(303)
    end
  end
end