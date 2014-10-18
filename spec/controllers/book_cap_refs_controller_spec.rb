require 'spec_helper'

describe BookCapRefsController do

  it_should_behave_like 'a protected controller', {
      :index  => :get,
      :create  => :post
  }

  context 'Actions with parameters' do
    it 'Should not be able to access show without start and LTI session' do
      bypass_rescue
      expect{ (get :edit, {:id => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'Should not be able to access update without start and LTI session' do
      bypass_rescue
      expect{ (post :update, {:id => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'Should not be able to access destroy without start and LTI session' do
      bypass_rescue
      expect{ (delete :destroy, {:id => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end
  end

end