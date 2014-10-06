require 'spec_helper'

describe AbstractsController do

  it_should_behave_like 'a protected controller', {
      :edit  => :get,
      :update => :post,
      :create  => :post
  }

end