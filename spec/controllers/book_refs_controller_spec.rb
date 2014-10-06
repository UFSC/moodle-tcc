require 'spec_helper'

describe BookRefsController do

  it_should_behave_like 'a protected controller', {
      :index  => :get,
      :create  => :post
  }

end