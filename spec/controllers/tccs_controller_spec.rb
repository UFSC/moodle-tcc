require 'spec_helper'

describe TccsController do

  it_should_behave_like 'a protected controller', {
      :show  => :get,
      :preview => :get,
      :update  => :post
  }

  before(:each) { bypass_rescue }

  context 'authenticated user' do

    before(:each) { request.session = fake_lti_session }

    it 'expects access to :generate via GET to be allowed' do
      expect { get :generate, format: 'pdf' }.not_to raise_error
    end
  end

  context 'unauthenticated user' do
    it 'expects access to :generate via GET to be denied' do
      expect { get :generate }.to raise_error (Authentication::UnauthorizedError)
    end
  end

end