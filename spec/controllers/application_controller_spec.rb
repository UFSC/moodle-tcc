require 'spec_helper'

describe ApplicationController do

  context 'when raises a UnauthorizedError' do
    controller do
      def index
        raise ApplicationController::UnauthorizedError
      end
    end

    describe 'should return an UnauthorizedError' do
      it 'redirects to the errors/unauthorized' do
        get :index
        expect(response).to render_template('errors/unauthorized')
      end
    end
  end

  context 'when raises a PersonNotFoundError' do
    controller do
      def custom
        raise ApplicationController::PersonNotFoundError
      end
    end

    specify "a custom action can be requested if routes are drawn manually" do
      routes.draw { get "custom" => "anonymous#custom" }

      get :custom
      expect(response).to render_template('errors/person_not_found')
    end
  end

  context 'when raises a CredentialsError' do
    controller do
      def index
        raise Authentication::LTI::CredentialsError
      end
    end

    describe 'should return an CredentialsError ' do
      it 'redirects to the errors/lti_credentials_error' do
        get :index
        expect(response).to render_template('errors/lti_credentials_error')
      end
    end
  end
end