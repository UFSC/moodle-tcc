require 'spec_helper'

describe "InstructorAdminTccs" do
  describe "GET /instructor_admin_tccs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get instructor_admin_tccs_path
      response.status.should be(200)
    end
  end
end
