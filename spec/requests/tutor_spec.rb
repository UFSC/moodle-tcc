#encoding: utf-8
require 'spec_helper'

describe 'Tutor' do
  describe 'GET /tutor' do

    before(:each) do
      model = Fabricate(:tcc_with_all)
      tcc = Tcc.where(id: model.id)

      allow(TutorGroup).to receive(:get_tutor_group).and_return(0)
      allow(TutorGroup).to receive(:get_tutor_group_name).and_return(Faker::Lorem.sentence(4))

      allow(Tcc).to receive_message_chain(:where).and_return(tcc)
    end

    xit 'should work with moodle and portfolio type' do
      page.set_rack_session(fake_lti_session('urn:moodle:role/td', 'portfolio'))
      visit tutor_index_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content('Lista de Portfólios')
    end

    xit 'should not work without moodle' do
      visit tutor_index_path
      expect(page.current_path).to eq(access_denied_path)
    end
  end
end