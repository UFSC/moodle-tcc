#encoding: utf-8
require 'spec_helper'

describe 'Tutor' do
  describe 'GET /tutor' do

    before(:each) do
      model = Fabricate(:tcc_with_all)
      tcc = Tcc.where(id: model.id)

      TutorGroup.stub(:get_tutor_group).and_return(0)
      TutorGroup.stub(:get_tutor_group_name).and_return(Faker::Lorem.sentence(4))

      Tcc.stub_chain(:where).and_return(tcc)
    end

    it 'should work with moodle and portfolio type' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/td', 'portfolio'))
      visit tutor_index_path

      page.current_path.should_not == access_denied_path
      page.should have_content('Lista de Portfólios')
    end

    it 'should not work without moodle' do
      visit tutor_index_path
      page.current_path.should == access_denied_path
    end
  end
end