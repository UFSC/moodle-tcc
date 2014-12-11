require 'spec_helper'

describe CompoundNamesController do

  it_should_behave_like 'a protected controller', {
      :index  => :get
  }

  let(:compound_name) { Fabricate(:compound_name) }

  before(:each) { bypass_rescue }

  context 'authenticated and authorized user' do

    before(:all) { @session = fake_lti_session(Authentication::Roles.administrator) }

    before(:each) { request.session = @session }

    it 'expects access to :create via POST to be allowed' do
      compound_name_attributes = Fabricate.attributes_for(:compound_name)
      expect { post :create, compound_name_attributes }.to_not raise_error
    end

    it 'expects access to :update via PATCH to be allowed' do
      expect { patch :update, {:id => compound_name.id} }.to_not raise_error
    end

    it 'expects access to :destroy via DELETE to be allowed' do
      expect { delete :destroy, {:id => compound_name.id} }.to_not raise_error
    end
  end

  context 'unauthenticated user' do
    it 'expects access to :create via POST to be denied' do
      expect { post :create, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'expects access to :update via PATCH to be denied' do
      expect { patch :update, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'expects access to :destroy via DELETE to be denied' do
      expect { delete :destroy, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end
  end
end