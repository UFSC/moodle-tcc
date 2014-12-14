require 'spec_helper'

describe ChaptersController do

  before(:each) { bypass_rescue }

  context 'authenticated user' do

    before(:all) { @session = fake_lti_session }

    before(:each) { request.session = @session }

    it 'should be able to access the verbs with authentication ' do
      expect { get :edit, {:position => 1} }.to_not raise_error
    end

    it 'should be able to access the verbs with authentication ' do
      chapter_attributes = Fabricate.attributes_for(:chapter)
      expect { post :save, {:position => 1, chapter: chapter_attributes} }.to_not raise_error
    end

    it 'should be able to access the verbs with authentication ' do
      expect { get :import, {:position => 1} }.to_not raise_error
    end

    it 'should be able to access the verbs with authentication ' do
      expect { post :execute_import, {:position => 1} }.to_not raise_error
    end

  end

  context 'unauthenticated user' do

    it 'should not be able to access show without start and LTI session' do
      expect { get :edit, {:position => 1} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'should not be able to access save without start and LTI session' do
      expect { post :save, {:position => 1} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'should not be able to access import without start and LTI session' do
      expect { get :import, {:position => 1} }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'should not be able to access execute_import without start and LTI session' do
      expect { (post :execute_import, {:position => 1}) }.to raise_error(Authentication::UnauthorizedError)
    end
  end
end