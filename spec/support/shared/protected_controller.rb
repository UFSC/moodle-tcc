shared_examples 'a protected controller' do |actions|

  context 'as a general controller' do
    actions.each_pair do |action, verb|
      specify "Should be able to access ##{action} via #{verb}" do
        page.set_rack_session(fake_lti_session)
        send(verb, action)
        expect{ response }.to_not raise_error
      end

      specify "Should not be able to access ##{action} via #{verb}" do
        bypass_rescue
        expect{ send(verb, action) }.to raise_error(Authentication::UnauthorizedError)
      end
    end
  end

end