require 'spec_helper'

describe BibliographiesController do

  it_should_behave_like 'a protected controller', {
      :index  => :get
  }

end