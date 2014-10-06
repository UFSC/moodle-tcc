require 'spec_helper'

describe ChaptersController do

  it_should_behave_like 'a protected controller', {
      # :show  => :get
      # :save  => :post,
      # :import => :get
  }

end