#encoding: utf-8
require 'spec_helper'

describe 'Hubs' do

  describe 'GET /chapters' do

    before :each do
      page.set_rack_session(fake_lti_session('student', 'tcc'))
      allow(Middleware::Orientadores).to receive_message_chain(:find_by_cpf, :nome).and_return(Faker::Name.name)
    end

  end

end
