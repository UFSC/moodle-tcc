require 'spec_helper'

describe InstructorAdminController do

  it_should_behave_like 'a protected controller', {
      :index  => :get,
      :autocomplete_tcc_name => :get
  }

end