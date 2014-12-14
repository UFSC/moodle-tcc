require 'spec_helper'

describe LtiController do

  it 'should be able to access establish_connection without start and LTI session' do
    request.session = fake_lti_session
    expect{ get :establish_connection }.to_not raise_error
  end

  it 'should not be able to access establish_connection without start and LTI session' do
    bypass_rescue
    expect{ get :establish_connection}.to raise_error(Authentication::LTI::CredentialsError)
  end
end