require 'spec_helper'

describe ChaptersController do

  context 'Actions with parameters' do

    it 'Should be able to access the verbs with authentication ' do
      page.set_rack_session(fake_lti_session)
      expect{ (get :show, {:position => 0}) }.to_not raise_error
    end

    it 'Should be able to access the verbs with authentication ' do
      page.set_rack_session(fake_lti_session)
      expect{ (post :save, {:position => 0}) }.to_not raise_error
    end

    it 'Should be able to access the verbs with authentication ' do
      page.set_rack_session(fake_lti_session)
      expect{ (get :import, {:position => 0}) }.to_not raise_error
    end

    it 'Should be able to access the verbs with authentication ' do
      page.set_rack_session(fake_lti_session)
      expect{ (post :execute_import, {:position => 0}) }.to_not raise_error
    end

    it 'Should not be able to access show without start and LTI session' do
      bypass_rescue
      expect{ (get :show, {:position => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'Should not be able to access save without start and LTI session' do
      bypass_rescue
      expect{ (post :save, {:position => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'Should not be able to access import without start and LTI session' do
      bypass_rescue
      expect{ (get :import, {:position => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end

    it 'Should not be able to access execute_import without start and LTI session' do
      bypass_rescue
      expect{ (post :execute_import, {:position => 0}) }.to raise_error(Authentication::UnauthorizedError)
    end
  end

end