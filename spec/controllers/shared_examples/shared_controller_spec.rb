require 'spec_helper'
include Authentication

shared_examples 'a protected controller' do |actions|

  # user = Authentication::User.new fake_lti_session

  context 'as a regular user' do
    actions.each_pair do |action, verb|
      specify "I should be able to access ##{action} via #{verb}" do
        send(verb, action)
        expect{ response }.to_not raise_error
      end
    end
  end

end