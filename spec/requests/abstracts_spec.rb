#encoding: utf-8
require 'spec_helper'

describe 'Abstract content' do

  let(:page_title) { I18n.t('activerecord.attributes.abstract.content_pt') }
  let(:content_field) { 'abstract_content' }
  let(:check_tcc_title) { true }
  let(:check_keyword) { true }
  let(:document_test) { tcc.abstract }
  let(:edit_path) { 'edit_abstracts_path' }
  let(:edit_path_position) { nil }

  describe '#student?' do
    let(:role_context) { 'student' }
    let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
    let(:person_session) {tcc.student}
    it_behaves_like 'view, edit and change state (as Student)'
  end

  context '#leader?' do
    let(:role_context) { 'urn:moodle:role/orientador' }
    let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
    let(:person_session) {tcc.orientador}
    it_behaves_like 'view, edit and change state (as viewAll)'
  end

  context '#admin?' do
    let(:role_context) { 'administrator' }
    let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
    let(:person_session) { lti_user.person }
    it_behaves_like 'view, edit and change state (as viewAll)'
  end

  context '#AVEA_coordinator?' do
    let(:role_context) { 'urn:moodle:role/coordavea' }
    let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
    let(:person_session) { lti_user.person }
    it_behaves_like 'view, edit and change state (as viewAll)'
  end

  context '#course_coordinator?' do
    let(:role_context) { 'urn:moodle:role/coordcurso' }
    let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
    let(:person_session) { lti_user.person }
    it_behaves_like 'view, edit and change state (as viewAll)'
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


