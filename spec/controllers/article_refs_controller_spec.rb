require 'spec_helper'

describe ArticleRefsController do

  it_should_behave_like 'a protected controller', {
      :index  => :get,
      :create  => :post,
  }

end