#encoding: utf-8
require 'spec_helper'

describe 'Chapter content' do

  let(:page_title) { document_test.chapter_definition.title }
  let(:content_field) { 'chapter_content' }
  let(:check_keyword) { false }
  let(:edit_path) { 'edit_chapters_path' }
  let(:edit_path_position) { document_test.position }

  shared_context 'import online text' do

    let(:tcc) {@tcc_1}
    let(:moodle_user_view) { tcc.student.moodle_id }
    let(:document_test) { tcc.chapters.first }


    before :each do
      @tcc_1 = Fabricate(:tcc_with_all)
      lti_user.person = person_session
      page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
      document_test.chapter_definition.coursemodule_id = Fabricate.sequence(:coursemodule_id)
      document_test.chapter_definition.save!
      document_test.content = '';
      document_test.save!
    end

    def make_http_request_local
      params = 'wstoken=59864ec673b9eadc141ec43d3e634065&wsfunction=local_wstcc_get_user_online_text_submission&moodlewsrestformat=json&userid=9633&coursemoduleid=5206'
      response = Net::HTTP.new('unasus2.local').post('/webservice/rest/server.php', params)
      puts "Response: #{response.body}"
      response.body
    end

    it 'edit empty',
       :vcr => {:cassette_name =>  'onlinetextSubmitted',
                :record => :new_episodes,
                :match_requests_on => [:query, :method]} do
      #expect(make_http_request_local).to include('onlinetext')
      visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
      # deve encontrar
      expect(page).to have_content('Não existe conteúdo ainda neste capítulo')
    end

    it 'edit import',
       :vcr => {:cassette_name =>  'onlinetextGraded',
                :record => :new_episodes,
                :match_requests_on => [:query, :method]} do
      #expect(make_http_request_local).to include('onlinetext')
      visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
      # deve encontrar
      expect(page).to have_content('Não existe conteúdo ainda neste capítulo')
      if (Pundit.policy(lti_user, tcc).import_chapters?)
        expect(page).to have_button('Importar texto da atividade do Moodle')
      else
        expect(page).to_not have_button('Importar texto da atividade do Moodle')
      end
    end
  end

  context '@first' do
    let(:document_test) { tcc.chapters.first }

    describe '#student?' do
      let(:role_context) { 'student' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) {tcc.student}
      it_behaves_like 'view, edit and change state (as Student)'
      it_behaves_like 'import online text'
    end

    context '#leader?' do
      let(:role_context) { 'urn:moodle:role/orientador' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context ) }
      let(:person_session) {tcc.orientador}
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#admin?' do
      let(:role_context) { 'administrator' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#AVEA_coordinator?' do
      let(:role_context) { 'urn:moodle:role/coordavea' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#course_coordinator?' do
      let(:role_context) { 'urn:moodle:role/coordcurso' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#tutoring_coordinator?' do
      let(:role_context) { 'urn:moodle:role/tutoria' }
      it_behaves_like 'an unauthorized user who cannot view abstract'
    end

    context '#tutor?' do
      let(:role_context) { 'urn:moodle:role/td' }
      it_behaves_like 'an unauthorized user who cannot view abstract'
    end

  end

  context '@last' do
    let(:document_test) { tcc.chapters.last }

    describe '#student?' do
      let(:role_context) { 'student' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) {tcc.student}
      it_behaves_like 'view, edit and change state (as Student)'
      it_behaves_like 'import online text'
    end

    context '#leader?' do
      let(:role_context) { 'urn:moodle:role/orientador' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context ) }
      let(:person_session) {tcc.orientador}
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#admin?' do
      let(:role_context) { 'administrator' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#AVEA_coordinator?' do
      let(:role_context) { 'urn:moodle:role/coordavea' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#course_coordinator?' do
      let(:role_context) { 'urn:moodle:role/coordcurso' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      it_behaves_like 'view, edit and change state (as viewAll)'
      it_behaves_like 'import online text'
    end

    context '#tutoring_coordinator?' do
      let(:role_context) { 'urn:moodle:role/tutoria' }
      it_behaves_like 'an unauthorized user who cannot view abstract'
    end

    context '#tutor?' do
      let(:role_context) { 'urn:moodle:role/td' }
      it_behaves_like 'an unauthorized user who cannot view abstract'
    end

  end

end
