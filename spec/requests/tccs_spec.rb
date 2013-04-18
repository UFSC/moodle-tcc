#encoding: utf-8
require 'spec_helper'

describe "Tccs" do
  describe "GET /tccs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tccs_path
      response.status.should be(200)
    end

    it "instructor admin not work without moodle" do
      visit tccs_path
      page.should have_content("wrong")
    end

    it "instructor admin work with moodle" do
      pending
    end
  end
end
