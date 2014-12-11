shared_examples 'a protected controller' do |actions|

  context 'as a general controller' do

    before(:each) { bypass_rescue }

    actions.each_pair do |action, verb|
      specify "expects the access ##{action} via #{verb} be allowed" do
        request.session = fake_lti_session

        send(verb, action)
        expect { response }.to_not raise_error
      end

      specify "expects the access ##{action} via #{verb} be denied" do
        expect { send(verb, action) }.to raise_error(Authentication::UnauthorizedError)
      end
    end
  end

end