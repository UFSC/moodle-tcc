require 'spec_helper'

describe "InstructorAdminTccs" do
  describe "GET /instructor_admin_tccs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get instructor_admin_tccs_path
      response.status.should be(200)
    end

    it "should work with moodle" do
      page.set_rack_session(:launch_params => 'test')  #to pass before_filter
      visit instructor_admin_tccs_path
      page.should have_content('Lista de TCCs')
    end

    it "should not work without moodle" do
      visit instructor_admin_tccs_path
      page.should have_content("wrong")
    end
  end
end
