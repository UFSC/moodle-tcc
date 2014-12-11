require 'spec_helper'

describe InstructorAdminController do

  before(:each) { bypass_rescue }

  context 'unauthenticated user' do
    it 'expects access denied for GET :index' do
      expect { get :index }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'expects access denied for GET :autocomplete_tcc_name' do
      expect { get :autocomplete_tcc_name }.to raise_error(Authentication::UnauthorizedError)
    end
  end

  context 'authenticated user with permission' do
    before(:all) { @session = fake_lti_session(Authentication::Roles.orientador) }

    before(:each) { request.session = @session }

    it 'expects access to GET :index be allowed' do
      expect { get :index }.not_to raise_error
    end

    it 'expects access to GET :autocomplete_tcc_name be allowed' do
      expect { get :autocomplete_tcc_name }.not_to raise_error
    end
  end

end