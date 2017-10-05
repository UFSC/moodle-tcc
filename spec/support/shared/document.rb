def mount_edit_path(edit_path, moodle_user=nil, position=nil)
  mounted_path = ''
  mounted_path += " moodle_user:#{moodle_user}" unless moodle_user.nil?
  if (!position.nil?)
    mounted_path += ', ' unless mounted_path == ''
    mounted_path += " position:#{position}"
  end
  mounted_path = edit_path+mounted_path
  eval(mounted_path)
end

shared_context 'view abstract fields' do |state|
  it "in #{state} state" do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{state}"))
    expect(page).to have_field(content_field)
    expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => true) if check_keyword
    expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => true) if check_tcc_title
    # não deve encontrar
    expect(page).to_not have_button(I18n.t(:save_document))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_done'))
  end
end

shared_context 'calling a CleaningBlankLinesError' do
  # required
  # document_test
  # Ex.: let(:document_test) { tcc.chapters.first }
  # Ex.: let(:document_test) { tcc.abstract }

  let(:tcc) {@tcc_1}
  let(:moodle_user_view) { nil }
  let(:role_context) { 'student' }
  let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
  let(:person_session) {tcc.student}

  before :each do
    @tcc_1 = Fabricate(:tcc_with_all)
    page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
  end

  it 'raises CleaningBlankLinesError' do
    error_key = Rails.application.secrets.error_key
    expect(error_key.present?).to be true

    document_test.content = "#{document_test.content}\r\n"+error_key
    expect { document_test.save! }.to raise_error(TccContent::CleaningBlankLinesError)
  end
end

shared_context 'view, edit and change state (as Student)' do

  let(:tcc) {@tcc_1}
  let(:moodle_user_view) { nil }

  before :each do
    @tcc_1 = Fabricate(:tcc_with_all)
    page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
  end

  context 'in Draft state' do

    it_behaves_like 'edit and save abstract fields in Draft with success', ''   , ''   , ''
    it_behaves_like 'edit and save abstract fields in Draft with success', 'qqq', ''   , ''
    it_behaves_like 'edit and save abstract fields in Draft with success', ''   , 'eee', ''
    it_behaves_like 'edit and save abstract fields in Draft with success', 'rrr', 'ttt', ''
    it_behaves_like 'edit and save abstract fields in Draft with success', ''   , ''   , 'yyy'
    it_behaves_like 'edit and save abstract fields in Draft with success', 'uuu', ''   , 'iii'
    it_behaves_like 'edit and save abstract fields in Draft with success', ''   , 'ooo', 'ppp'
    it_behaves_like 'edit and save abstract fields in Draft with success', 'aaa', 'sss', 'ddd'

    context 'send do review with sucess' do
      it 'empty fields' do
        visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
        # deve encontrar na página
        expect(page).to have_content(I18n.t('activerecord.state_machines.states.empty'))
        expect(page).to have_button(I18n.t(:save_document))
        expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_review'))
        # envia para revisão
        click_button I18n.t('activerecord.state_machines.events.to_review')
        # deve encontrar na página
        expect(page).to have_content(I18n.t('activerecord.state_machines.states.review'))
        expect(page).to have_field(content_field)
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => true)  if check_keyword
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => true) if check_tcc_title
        # não deve encontrar
        expect(page).to_not have_button(I18n.t(:save_document))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_draft'))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_done'))
      end
    end
  end

  context 'in Review state' do

    before :each do
      document_test.to_draft
      document_test.to_review
    end

    context 'view content' do
      it_behaves_like 'view abstract fields', 'review'
    end
  end

  context 'in Done state' do

    before :each do
      document_test.to_draft
      document_test.to_review
      document_test.to_done
    end

    context 'view content' do
      it_behaves_like 'view abstract fields', 'done'
    end
  end
end

shared_context 'view, edit and change state (as viewAll)' do

  let(:tcc) {@tcc_1}
  let(:moodle_user_view) { tcc.student.moodle_id }

  before :each do
    @tcc_1 = Fabricate(:tcc_with_all)
    page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
  end

  context 'in draft state' do
    before :each do
      document_test.to_draft
    end

    it_behaves_like 'view abstract fields', 'draft'
  end

  context 'in done state' do
    before :each do
      document_test.to_draft
      document_test.to_review
      document_test.to_done
    end
    it_behaves_like 'view abstract fields', 'done'
  end

  context 'in review state' do
    before :each do
      document_test.to_draft
      document_test.to_review
    end

    it_behaves_like 'edit and save abstract fields in Review with success', ''   , ''   , ''
    it_behaves_like 'edit and save abstract fields in Review with success', 'qqq', ''   , ''
    it_behaves_like 'edit and save abstract fields in Review with success', ''   , 'eee', ''
    it_behaves_like 'edit and save abstract fields in Review with success', 'rrr', 'ttt', ''
    it_behaves_like 'edit and save abstract fields in Review with success', ''   , ''   , 'yyy'
    it_behaves_like 'edit and save abstract fields in Review with success', 'uuu', ''   , 'iii'
    it_behaves_like 'edit and save abstract fields in Review with success', ''   , 'ooo', 'ppp'
    it_behaves_like 'edit and save abstract fields in Review with success', 'aaa', 'sss', 'ddd'

    it_behaves_like 'edit fields in Review and send back to student with success', ''   , ''   , ''
    it_behaves_like 'edit fields in Review and send back to student with success', 'qqq', ''   , ''
    it_behaves_like 'edit fields in Review and send back to student with success', ''   , 'eee', ''
    it_behaves_like 'edit fields in Review and send back to student with success', 'rrr', 'ttt', ''
    it_behaves_like 'edit fields in Review and send back to student with success', ''   , ''   , 'yyy'
    it_behaves_like 'edit fields in Review and send back to student with success', 'uuu', ''   , 'iii'
    it_behaves_like 'edit fields in Review and send back to student with success', ''   , 'ooo', 'ppp'
    it_behaves_like 'edit fields in Review and send back to student with success', 'aaa', 'sss', 'ddd'

    it_behaves_like 'edit fields in Review and evaluate with success', ''   , ''   , ''
    it_behaves_like 'edit fields in Review and evaluate with success', 'qqq', ''   , ''
    it_behaves_like 'edit fields in Review and evaluate with success', ''   , 'eee', ''
    it_behaves_like 'edit fields in Review and evaluate with success', 'rrr', 'ttt', ''
    it_behaves_like 'edit fields in Review and evaluate with success', ''   , ''   , 'yyy'
    it_behaves_like 'edit fields in Review and evaluate with success', 'uuu', ''   , 'iii'
    it_behaves_like 'edit fields in Review and evaluate with success', ''   , 'ooo', 'ppp'
    it_behaves_like 'edit fields in Review and evaluate with success', 'aaa', 'sss', 'ddd'

  end
end

shared_context 'edit and save abstract fields in Draft with success' do |content, keyword, tcc_title|
  before :each do
    document_test.content = ''
    document_test.keywords = '' if check_keyword
  end

  it 'in edit view' do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.empty'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_review'))
    if (!content.nil? && !content.empty?)
      fill_in content_field, :with => content
    end
    if (check_keyword && !keyword.nil? && !keyword.empty?)
      fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword
    end
    if (check_tcc_title && !tcc_title.nil? && !tcc_title.empty?)
      fill_in I18n.t('activerecord.attributes.title.title'), :with => tcc_title
    end
    # salva
    click_button I18n.t(:save_document)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.draft'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_review'))
    if (!content.nil? && !content.empty?)
      expect(page).to have_field(content_field, :with => content)
    else
      expect(page).to have_field(content_field)
    end
    if (check_keyword)
      if (!keyword.nil? && !keyword.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => false)
      end
    end
    if (check_tcc_title)
      if (!tcc_title.nil? && !tcc_title.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :with => tcc_title)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => false)
      end
    end
    expect(page).to have_content(:success)
    # não deve encontrar
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_done'))
  end
end

shared_context 'edit and save abstract fields in Review with success' do |content, keyword, tcc_title|
  before :each do
    document_test.content = ''
    document_test.keywords = '' if check_keyword
  end

  it 'in edit view' do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.review'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_done'))
    if (!content.nil? && !content.empty?)
      fill_in content_field, :with => content
    end
    if (check_keyword && !keyword.nil? && !keyword.empty?)
      fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword
    end
    if (check_tcc_title && !tcc_title.nil? && !tcc_title.empty?)
      fill_in I18n.t('activerecord.attributes.title.title'), :with => tcc_title
    end
    # salva
    click_button I18n.t(:save_document)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.review'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_done'))
    if (!content.nil? && !content.empty?)
      expect(page).to have_field(content_field, :with => content)
    else
      expect(page).to have_field(content_field)
    end
    if (check_keyword)
      if (!keyword.nil? && !keyword.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => false)
      end
    end
    if (check_tcc_title)
      if (!tcc_title.nil? && !tcc_title.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :with => tcc_title)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => false)
      end
    end
    expect(page).to have_content(:success)
    # não deve encontrar
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
  end
end


shared_context 'edit fields in Review and send back to student with success' do |content, keyword, tcc_title|
  before :each do
    document_test.content = ''
    document_test.keywords = '' if check_keyword
  end

  it 'in edit view' do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.review'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_done'))
    if (!content.nil? && !content.empty?)
      fill_in content_field, :with => content
    end
    if (check_keyword && !keyword.nil? && !keyword.empty?)
      fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword
    end
    if (check_tcc_title && !tcc_title.nil? && !tcc_title.empty?)
      fill_in I18n.t('activerecord.attributes.title.title'), :with => tcc_title
    end
    # devolve para o estudante
    click_button I18n.t('activerecord.state_machines.events.to_draft')
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.draft'))
    if (!content.nil? && !content.empty?)
      expect(page).to have_field(content_field, :with => content)
    else
      expect(page).to have_field(content_field)
    end
    if (check_keyword)
      if (!keyword.nil? && !keyword.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword, :disabled => true)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => true)
      end
    end
    if (check_tcc_title)
      if (!tcc_title.nil? && !tcc_title.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :with => tcc_title, :disabled => true)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => true)
      end
    end
    expect(page).to have_content(:success)
    # não deve encontrar
    expect(page).to_not have_button(I18n.t(:save_document))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_done'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
  end
end

shared_context 'edit fields in Review and evaluate with success' do |content, keyword, tcc_title|
  before :each do
    document_test.content = ''
    document_test.keywords = '' if check_keyword
  end

  it 'in edit view' do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.review'))
    expect(page).to have_button(I18n.t(:save_document))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to have_button(I18n.t('activerecord.state_machines.events.to_done'))
    if (!content.nil? && !content.empty?)
      fill_in content_field, :with => content
    end
    if (check_keyword && !keyword.nil? && !keyword.empty?)
      fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword
    end
    if (check_tcc_title && !tcc_title.nil? && !tcc_title.empty?)
      fill_in I18n.t('activerecord.attributes.title.title'), :with => tcc_title
    end
    # aprova
    click_button I18n.t('activerecord.state_machines.events.to_done')
    # deve encontrar na página
    expect(page).to have_content(page_title)
    expect(page).to have_content(I18n.t('activerecord.state_machines.states.done'))
    if (!content.nil? && !content.empty?)
      expect(page).to have_field(content_field, :with => content)
    else
      expect(page).to have_field(content_field)
    end
    if (check_keyword)
      if (!keyword.nil? && !keyword.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :with => keyword, :disabled => true)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.abstract.keywords'), :disabled => true)
      end
    end
    if (check_tcc_title)
      if (!tcc_title.nil? && !tcc_title.empty?)
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :with => tcc_title, :disabled => true)
      else
        expect(page).to have_field(I18n.t('activerecord.attributes.title.title'), :disabled => true)
      end
    end
    expect(page).to have_content(:success)
    # não deve encontrar
    expect(page).to_not have_button(I18n.t(:save_document))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_draft'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_done'))
    expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
  end
end

shared_context 'an unauthorized user who cannot view abstract' do
  let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
  let(:person_session) { lti_user.person }
  let(:tcc) {@tcc_1}
  let(:moodle_user_view) { tcc.student.moodle_id }

  before :each do
    @tcc_1 = Fabricate(:tcc_with_all)
    page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
  end
  it "for role context" do
    visit mount_edit_path(edit_path, moodle_user_view, edit_path_position)
    # não deve encontrar na página
    expect(page).to_not have_content(page_title)
  end
end
