require 'spec_helper'

describe TccsController do
  before(:each) do
    controller.should_receive(:authorize)
  end

  describe 'GET index' do

    it 'should accepts lti autenticated users' do
      get(:index, parameters=nil, session=fake_lti_session)
      response.status.should be(200)
    end

  end

end
