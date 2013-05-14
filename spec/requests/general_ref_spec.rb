require 'spec_helper'

describe 'GeneralRef' do
  describe 'GET /general_refs.json' do
    before(:all) do
      @tcc = Fabricate(:tcc)
    end

    after(:all) do
      @tcc.destroy
    end

    it 'should work with moodle' do
      page.set_rack_session(fake_lti_session)
      visit general_refs_path(:format => :json)

      page.current_path.should_not == access_denied_path
      #page.should have_content('general_refs')
    end

    it 'should not work without moodle' do
      visit general_refs_path
      page.current_path.should == access_denied_path
    end
  end
end
