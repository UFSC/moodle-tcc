require 'spec_helper'

describe 'GeneralRef' do
  describe 'GET /general_refs.json' do
    xit 'should work with moodle' do
      page.set_rack_session(fake_lti_session)
      visit general_refs_path(:format => :json)

      expect(page.current_path).not_to eq(access_denied_path)
      #page.should have_content('general_refs')
    end

    xit 'should not work without moodle' do
      visit general_refs_path
      expect(page.current_path).to eq(access_denied_path)
    end
  end
end
