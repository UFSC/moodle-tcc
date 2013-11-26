#encoding: utf-8
require 'spec_helper'

describe 'Hubs' do

  describe 'GET /hubs' do

    before :each do
      page.set_rack_session(fake_lti_session('student', 'tcc'))
      Middleware::Orientadores.stub_chain(:find_by_cpf, :nome).and_return(Faker::Name.name)
    end

  end

end
