require 'spec_helper'

describe TccsController do

  it_should_behave_like 'a protected controller', {
      :edit  => :get,
      :generate  => :get,
      :preview => :get,
      :update  => :post
  }

end