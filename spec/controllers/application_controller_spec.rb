require 'spec_helper'

describe ApplicationController do

  context 'when raises a UnauthorizedError' do
    controller do
      def index
        raise Authentication::UnauthorizedError
      end
    end

    describe 'should return an UnauthorizedError' do
      it 'renders the errors/unauthorized' do
        get :index
        expect(response).to render_template('errors/unauthorized')
      end
    end
  end

  context 'when raises a TccNotFoundError' do
    controller do
      skip_before_action :authorize_lti
      skip_before_action :get_tcc

      def index
        raise LtiTccFilters::TccNotFoundError
      end
    end

    describe 'should return a TccNotFoundError' do
      it 'renders the errors/tcc_not_found' do
        get :index
        expect(response).to render_template('errors/tcc_not_found')
      end
    end
  end

  context 'when raises a PersonNotFoundError' do
    controller do
      skip_before_action :authorize_lti
      skip_before_action :get_tcc

      def custom
        raise Authentication::PersonNotFoundError
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
      skip_before_action :authorize_lti
      skip_before_action :get_tcc

      def index
        raise Authentication::LTI::CredentialsError
      end
    end

    describe 'should return an CredentialsError ' do
      it 'renders the errors/lti_credentials_error' do
        get :index
        expect(response).to render_template('errors/lti_credentials_error')
      end
    end
  end
end