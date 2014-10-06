require 'spec_helper'

describe LtiController do

  it_should_behave_like 'a protected controller', {
      :establish_connection  => :get,
      :access_denied  => :get
  }

end