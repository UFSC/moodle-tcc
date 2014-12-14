require 'spec_helper'

describe ArticleRefsController do

  it_should_behave_like 'a protected controller', {
      :create  => :post,
      :index => :get
  }

  context 'Actions with parameters' do

    before(:each) { bypass_rescue }

    it 'should not be able to access show without start and LTI session' do
      expect { get :edit, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'should not be able to access update without start and LTI session' do
      expect { post :update, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'should not be able to access destroy without start and LTI session' do
      expect { delete :destroy, {:id => 0} }.to raise_error(Authentication::UnauthorizedError)
    end
  end
end