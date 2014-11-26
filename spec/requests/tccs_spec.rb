#encoding: utf-8
require 'spec_helper'
require 'pdf/inspector'

def mount_visit_path(visit_path, moodle_user=nil, position=nil)
  mounted_path = ''
  mounted_path += " moodle_user:#{moodle_user}" unless moodle_user.nil?
  if (!position.nil?)
    mounted_path += ', ' unless mounted_path == ''
    mounted_path += " position:#{position}"
  end
  mounted_path = visit_path+mounted_path
  eval(mounted_path)
end

shared_context 'cannot giving grade' do
  it 'even if all the chapters are evaluated and five references are included' do
    tcc.abstract.to_done_admin!
    tcc.abstract.save!
    tcc.chapters.each do |chapter|
      chapter.to_done_admin!
      chapter.save!
    end
    (1..5).each do
      a_ref = Reference.new
      a_book = Fabricate(:book_ref)
      a_ref.tcc = tcc
      a_ref.element = a_book
      a_ref.save!
    end
    tcc.save!
    tcc.reload
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{@tcc_1.id}"
    expect(page).to_not have_link(modal_frame)
  end
end

shared_context 'can giving grade' do
  it 'if all the chapters are evaluated and five references are included' do
    tcc.abstract.to_done_admin!
    tcc.abstract.save!
    tcc.chapters.each do |chapter|
      chapter.to_done_admin!
      chapter.save!
    end
    (1..5).each do
      a_ref = Reference.new
      a_book = Fabricate(:book_ref)
      a_ref.tcc = tcc
      a_ref.element = a_book
      a_ref.save!
    end
    tcc.save!
    tcc.reload
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{@tcc_1.id}"
    click_link modal_frame
    modal = page.find(modal_frame)
    expect(modal).to have_content('Avaliação')
    expect(modal).to have_field('tcc[grade]')
    a_grade = 1 + Random.rand(99)
    within modal_frame do
      fill_in 'tcc[grade]', :with => a_grade
      allow_any_instance_of(MoodleAPI::MoodleGrade).to receive(:set_grade_lti) { ['empty reponse'] }
      click_button I18n.t(:btn_evaluate)
    end
    tcc.reload
    expect(@tcc_1.grade).to eql(a_grade)
    click_link modal_frame
    modal = page.find(modal_frame)
    expect(modal).to have_content('Avaliação')
    expect(modal).to have_field('tcc[grade]', :with => a_grade)
    expect(modal).to_not have_field('tcc[grade]', :with => "#{a_grade}.0+")
    expect(modal).to_not have_field('tcc[grade]', :with => "#{a_grade},0+")
  end

  it 'only if all OK' do
    tcc.abstract.to_done_admin!
    tcc.abstract.save!
    tcc.chapters.each do |chapter|
      chapter.to_done_admin!
      chapter.save!
    end
    (1..5).each do
      a_ref = Reference.new
      a_book = Fabricate(:book_ref)
      a_ref.tcc = tcc
      a_ref.element = a_book
      a_ref.save!
    end
    tcc.save!
    tcc.reload
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{@tcc_1.id}"
    click_link modal_frame
    modal = page.find(modal_frame)
    expect(modal).to have_content('Avaliação')
    expect(modal).to have_field('tcc[grade]')
    a_grade = 1 + Random.rand(99)
    within modal_frame do
      fill_in 'tcc[grade]', :with => a_grade
      allow_any_instance_of(MoodleAPI::MoodleGrade).to receive(:set_grade_lti) { ['empty reponse'] }
      click_button I18n.t(:btn_evaluate)
    end
    tcc.reload
    expect(@tcc_1.grade).to eql(a_grade)
    click_link modal_frame
    modal = page.find(modal_frame)
    expect(modal).to have_content('Avaliação')
    expect(modal).to have_field('tcc[grade]', :with => a_grade)
    expect(modal).to_not have_field('tcc[grade]', :with => "#{a_grade}.0+")
    expect(modal).to_not have_field('tcc[grade]', :with => "#{a_grade},0+")

    # abstract
    tcc.abstract.to_review_admin
    tcc.abstract.save!
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to_not have_link(modal_frame)
    tcc.abstract.to_done_admin
    tcc.abstract.save!
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to have_link(modal_frame)

    # chapter
    tcc.chapters.first.to_review_admin
    tcc.chapters.first.save!
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to_not have_link(modal_frame)
    tcc.chapters.first.to_done_admin
    tcc.chapters.first.save!
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to have_link(modal_frame)

    # reference
    tcc.references.first.destroy
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to_not have_link(modal_frame)
    a_ref = Reference.new
    a_book = Fabricate(:book_ref)
    a_ref.tcc = tcc
    a_ref.element = a_book
    a_ref.save!
    tcc.reload
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(@tcc_1.student.name)
    modal_frame = "##{tcc.id}"
    expect(page).to have_link(modal_frame)

  end
end

shared_context 'admin/AVEA user' do
  it 'not finding the field defense date' do
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    expect(page).to_not have_field(I18n.t('activerecord.attributes.tcc.defense_date'))
  end

  it 'does an edition in the defense date and save' do
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    select '31', :from => 'tcc_defense_date_3i'
    select 'Dezembro', :from => 'tcc_defense_date_2i'
    select Date.today().year.to_s, :from => 'tcc_defense_date_1i'

    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)
  end

  it 'does an edition in the defense date and preview the tcc with that text included' do
    a_date = '31-12-'+Date.today().year.to_s
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    select '31', :from => 'tcc_defense_date_3i'
    select 'Dezembro', :from => 'tcc_defense_date_2i'
    select Date.today().year.to_s, :from => 'tcc_defense_date_1i'

    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit mount_visit_path('preview_tcc_path', moodle_user_view)
    expect(page).to have_content(a_date)
  end

  it 'does an edition in the defense date and generate the tcc with that text included' do
    a_date = 'Dezembro de 2014'
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    select '31', :from => 'tcc_defense_date_3i'
    select 'Dezembro', :from => 'tcc_defense_date_2i'
    select Date.today().year.to_s, :from => 'tcc_defense_date_1i'

    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit "#{mount_visit_path('generate_tcc_path', moodle_user_view)}.pdf"
    sleep(5)
    text_analysis = PDF::Inspector::Text.analyze(page.body)
    expect(text_analysis.strings.join(' ')).to be_include(a_date.gsub(' ',''))
  end

  # cannot edit in draft and done
  it_behaves_like 'for view_all users'
end

shared_context 'for view_all users' do

  # view and edit tcc data
  it_behaves_like 'tcc user data information'

  # edit abstract/chapter and preview/generate
  it_behaves_like 'does an edition in a document' do
    before :each do
      tcc.abstract.to_review_admin
      tcc.abstract.save!
      tcc.chapters.each do |chapter|
        chapter.to_review_admin
        chapter.save!
      end
      tcc.save!
      tcc.reload
    end
  end

  it 'viewing tcc list information' do
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(I18n.t(:tcc_list_general_view))
    expect(page).to have_content(I18n.t(:list_refresh))
  end

  context 'in draft state' do
    it 'cannot edit abstract form' do
      visit mount_visit_path('edit_abstracts_path', moodle_user_view)
      expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:draft}"))
      expect(page).to_not have_button(I18n.t(:save_document))
      expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
    end

    it 'cannot edit chapter form' do
      visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
      expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:draft}"))
      expect(page).to_not have_button(I18n.t(:save_document))
      expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
    end
  end

  context 'in done state' do
    it 'cannot edit abstract form' do
      tcc.abstract.to_done_admin
      tcc.abstract.save!
      visit mount_visit_path('edit_abstracts_path', moodle_user_view)
      expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:done}"))
      expect(page).to_not have_button(I18n.t(:save_document))
      expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
    end

    it 'cannot edit chapter form' do
      tcc.chapters.first.to_done_admin
      tcc.chapters.first.save!
      visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
      expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:done}"))
      expect(page).to_not have_button(I18n.t(:save_document))
      expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
    end
  end
end

shared_context 'tcc user data information' do
  it 'viewing form with user information' do
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    expect(page).to have_field(I18n.t('activerecord.attributes.tcc.title'), :disabled => false)
    expect(page).to have_field(I18n.t('activerecord.attributes.tcc.student'), :disabled => true)
    expect(page).to have_field(I18n.t('activerecord.attributes.tcc.orientador'), :disabled => true)
  end

  it 'does an edition and save form with user information' do
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    fill_in I18n.t('activerecord.attributes.tcc.title'), :with => attributes[:title]
    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)
  end

  it 'does an edition in the tcc title and preview the tcc with that text included' do
    a_title = attributes[:title]
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    fill_in I18n.t('activerecord.attributes.tcc.title'), :with => a_title
    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit mount_visit_path('preview_tcc_path', moodle_user_view)
    expect(page).to have_content(a_title)
  end

  it 'does an edition in the tcc title (nil) and preview the tcc with that text included' do
    a_title = nil
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    fill_in I18n.t('activerecord.attributes.tcc.title'), :with => a_title
    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit mount_visit_path('preview_tcc_path', moodle_user_view)
    expect(page).to have_content(tcc.student.name)
  end

  it 'does an edition tcc title and generate the tcc with that text included' do
    a_title = attributes[:title]
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    fill_in I18n.t('activerecord.attributes.tcc.title'), :with => a_title
    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit "#{mount_visit_path('generate_tcc_path', moodle_user_view)}.pdf"
    sleep(5)
    text_analysis = PDF::Inspector::Text.analyze(page.body)
    expect(text_analysis.strings.join(' ')).to be_include(a_title.gsub(' ',''))
  end

  it 'does an edition tcc title (nil) and generate the tcc with that text included' do
    a_title = nil
    visit mount_visit_path('tcc_path', moodle_user_view)
    expect(page).to have_content(I18n.t(:data))
    fill_in I18n.t('activerecord.attributes.tcc.title'), :with => a_title
    click_button I18n.t(:save_changes_tcc)
    expect(page).to have_content(:successfully_saved)

    visit "#{mount_visit_path('generate_tcc_path', moodle_user_view)}.pdf"
    sleep(5)
    text_analysis = PDF::Inspector::Text.analyze(page.body)
    expect(text_analysis.strings.join(' ')).to be_include(tcc.student.name.gsub(' ',''))
  end

end

shared_context 'viewing tcc list' do
  it 'information' do
    visit instructor_admin_path
    expect(page).to have_content(I18n.t(:tcc_list))
    expect(page).to have_content(I18n.t(:tcc_list_general_view))
    expect(page).to have_content(I18n.t(:list_refresh))
  end
end

shared_context 'does an edition in a document' do
  it 'abstract and preview the tcc with that text included' do
    visit mount_visit_path('edit_abstracts_path', moodle_user_view)
    a_content = Faker::Lorem.paragraph(3)
    a_keywords = Faker::Lorem.words(3).join(' ')
    fill_in 'abstract_content', :with => a_content
    fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => a_keywords
    click_button I18n.t(:save_document)
    expect(page).to have_content(I18n.t(:successfully_saved))

    visit mount_visit_path('preview_tcc_path', moodle_user_view)
    expect(page).to have_content(a_keywords)
    expect(page).to have_content(a_content)
  end

  it 'chapter and preview the tcc with that text included' do
    a_content = Faker::Lorem.paragraph(3)
    visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
    fill_in 'chapter_content', :with => a_content
    click_button I18n.t(:save_document)
    expect(page).to have_content(I18n.t(:successfully_saved))

    visit mount_visit_path('preview_tcc_path', moodle_user_view)
    expect(page).to have_content(a_content)
  end

  it 'abstract and generate the tcc with that text included' do
    visit mount_visit_path('edit_abstracts_path', moodle_user_view)
    a_content = Faker::Lorem.words(3).join(' ')
    a_keywords = Faker::Lorem.words(3).join(' ')
    fill_in 'abstract_content', :with => a_content
    fill_in I18n.t('activerecord.attributes.abstract.keywords'), :with => a_keywords
    click_button I18n.t(:save_document)
    expect(page).to have_content(I18n.t(:successfully_saved))

    visit "#{mount_visit_path('generate_tcc_path', moodle_user_view)}.pdf"
    sleep(5)
    text_analysis = PDF::Inspector::Text.analyze(page.body)
    expect(text_analysis.strings.join(' ')).to include(a_content.gsub(' ',''))
    expect(text_analysis.strings.join(' ')).to include(a_keywords.gsub(' ',''))
  end

  it 'chapter and generate the tcc with that text included' do
    visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
    a_content = Faker::Lorem.words(3).join(' ')
    fill_in 'chapter_content', :with => a_content
    click_button I18n.t(:save_document)
    expect(page).to have_content(I18n.t(:successfully_saved))

    visit "#{mount_visit_path('generate_tcc_path', moodle_user_view)}.pdf"
    sleep(5)
    text_analysis = PDF::Inspector::Text.analyze(page.body)
    expect(text_analysis.strings.join(' ')).to include(a_content.gsub(' ',''))
  end
end

describe 'Tccs' do

  let(:attributes) { Fabricate.attributes_for(:tcc) }
  let(:tcc) { Fabricate(:tcc) }

  describe 'GET /tcc' do
    it 'should not work without LTI connection' do
      get tcc_path
      expect(response).to render_template('errors/unauthorized')
    end

    it 'should work with LTI connection' do
      page.set_rack_session(fake_lti_session('student'))
      visit tcc_path

      expect(page.current_path).not_to eq(access_denied_path)
      expect(page).to have_content(I18n.t(:data))
    end

    describe 'edit' do
      before :each do
        page.set_rack_session(fake_lti_session('student'))
        visit tcc_path
      end

      it 'tcc data' do
        click_link I18n.t(:data)
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.student'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.title'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.orientador'))
        expect(page).to have_content(I18n.t('activerecord.attributes.tcc.defense_date'))
      end

      it 'tcc abstract' do
        click_link I18n.t(:abstract)
        expect(page).to have_content(I18n.t(:abstract))
      end

      it 'tcc chapter 1' do
        click_link 'Capítulo 1'
        expect(page).to have_content('Capítulo 1')
      end

      it 'tcc chapter 2' do
        click_link 'Capítulo 2'
        expect(page).to have_content('Capítulo 2')
      end

      it 'tcc chapter 3' do
        click_link 'Capítulo 3'
        expect(page).to have_content('Capítulo 3')
      end

      it 'tcc bibliographies' do
        click_link 'Referências'
        expect(page).to have_content('Referências')
      end
    end
  end

  context 'login as student user' do

    let(:role_context) { 'student' }
    let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
    let(:person_session) {tcc.student}
    let(:tcc) {@tcc_1}
    let(:attributes) { Fabricate.attributes_for(:tcc) }
    let(:moodle_user_view) { nil }

    before :each do
      @tcc_1 = Fabricate(:tcc_with_all)
      page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
    end

    it 'having field defense date disabled' do
      visit mount_visit_path('tcc_path', moodle_user_view)
      expect(page).to have_content(I18n.t(:data))
      expect(page).to have_field(I18n.t('activerecord.attributes.tcc.defense_date'), :disabled => true)
    end

    # view and edit tcc data
    it_behaves_like 'tcc user data information'

    # edit abstract/chapter and preview/generate
    it_behaves_like 'does an edition in a document'

    it 'cannot view list information' do
      visit instructor_admin_path
      expect(page).to_not have_content(I18n.t(:tcc_list))
      expect(page).to_not have_content(I18n.t(:tcc_list_general_view))
      expect(page).to_not have_content(I18n.t(:list_refresh))
    end

    context 'in review state' do
      it 'abstract form' do
        tcc.abstract.to_review_admin
        tcc.abstract.save!
        visit mount_visit_path('edit_abstracts_path', moodle_user_view)
        expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:review}"))
        expect(page).to_not have_button(I18n.t(:save_document))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
      end

      it 'chapter form' do
        tcc.chapters.first.to_review_admin
        tcc.chapters.first.save!
        visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
        expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:review}"))
        expect(page).to_not have_button(I18n.t(:save_document))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
      end
    end

    context 'in done state' do
      it 'cannot edit abstract form' do
        tcc.abstract.to_done_admin
        tcc.abstract.save!
        visit mount_visit_path('edit_abstracts_path', moodle_user_view)
        expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:done}"))
        expect(page).to_not have_button(I18n.t(:save_document))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))

      end

      it 'cannot edit chapter form' do
        tcc.chapters.first.to_done_admin
        tcc.chapters.first.save!
        visit mount_visit_path('edit_chapters_path', moodle_user_view, '1')
        expect(page).to have_content(I18n.t("activerecord.state_machines.states.#{:done}"))
        expect(page).to_not have_button(I18n.t(:save_document))
        expect(page).to_not have_button(I18n.t('activerecord.state_machines.events.to_review'))
      end
    end
  end

  context 'instructor admin view (only one Tcc)' do
    before(:each)  do
      @tcc_1 = Fabricate(:tcc_with_all)
      @tcc_1_user = Authentication::User.new fake_lti_tp('student')
      @tcc_1_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
      @tcc_1_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

      @tcc_1_user.person    = @tcc_1.student
      @tcc_1_leader.person  = @tcc_1.orientador
      @tcc_1_tutor.person   = @tcc_1.tutor
      @tcc_1.save!
      @tcc_1.reload
    end

    after(:each) do
      @tcc_1.destroy
    end

    context 'login as leader user' do
      let(:role_context) { 'urn:moodle:role/orientador' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:tcc) {@tcc_1}
      let(:person_session) { tcc.orientador }
      let(:attributes) { Fabricate.attributes_for(:tcc) }
      let(:moodle_user_view) { tcc.student.moodle_id }

      before(:each) do
        page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
      end

      it 'having field defense date disabled' do
        visit mount_visit_path('tcc_path', moodle_user_view)
        expect(page).to have_content(I18n.t(:data))
        expect(page).to have_field(I18n.t('activerecord.attributes.tcc.defense_date'), :disabled => true)
      end

      # cannot edit in draft and done
      it_behaves_like 'for view_all users'

      it_behaves_like 'can giving grade'
    end

    context 'login as admin user' do
      let(:role_context) { 'administrator' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}
      let(:attributes) { Fabricate.attributes_for(:tcc) }
      let(:moodle_user_view) { tcc.student.moodle_id }

      before(:each) do
        page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
      end

      it_behaves_like 'admin/AVEA user'

      it_behaves_like 'can giving grade'

    end

    context 'as AVEA user' do
      let(:role_context) { 'urn:moodle:role/coordavea' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:tcc) {@tcc_1}
      let(:person_session) { lti_user.person }
      let(:attributes) { Fabricate.attributes_for(:tcc) }
      let(:moodle_user_view) { tcc.student.moodle_id }

      before(:each) do
        page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
      end

      it_behaves_like 'admin/AVEA user'

      it_behaves_like 'can giving grade'

    end

    context 'as course coordinator user' do
      let(:role_context) { 'urn:moodle:role/coordcurso' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:tcc) {@tcc_1}
      let(:person_session) { lti_user.person }
      let(:attributes) { Fabricate.attributes_for(:tcc) }
      let(:moodle_user_view) { tcc.student.moodle_id }

      before(:each) do
        page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
      end

      it_behaves_like 'for view_all users'

      it_behaves_like 'cannot giving grade'

    end
  end

  context 'instructor admin view (many Tccs)' do
    before(:each)  do
      @tcc_1 = Fabricate(:tcc_with_all)
      @tcc_1_user = Authentication::User.new fake_lti_tp('student')
      @tcc_1_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
      @tcc_1_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

      @tcc_1_user.person    = @tcc_1.student
      @tcc_1_leader.person  = @tcc_1.orientador
      @tcc_1_tutor.person   = @tcc_1.tutor
      @tcc_1.save!
      @tcc_1.reload

      @tcc_2 = Fabricate(:tcc_with_all)
      @tcc_2.tcc_definition = @tcc_1.tcc_definition
      @tcc_2_user = Authentication::User.new fake_lti_tp('student')
      @tcc_2_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

      @tcc_2_user.person    = @tcc_2.student
      @tcc_2.orientador     = @tcc_1.orientador
      @tcc_2_tutor.person   = @tcc_2.tutor
      @tcc_2.save!
      @tcc_2.reload

      @tcc_3 = Fabricate(:tcc_with_all)
      @tcc_3.tcc_definition = @tcc_1.tcc_definition
      @tcc_3_user = Authentication::User.new fake_lti_tp('student')
      @tcc_3_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')

      @tcc_3_user.person    = @tcc_3.student
      @tcc_3_leader.person  = @tcc_3.orientador
      @tcc_3.tutor          = @tcc_1.tutor
      @tcc_3.save!
      @tcc_3.reload

      @other_tcc = Fabricate(:tcc_with_all)
      @other_tcc.tcc_definition = @tcc_1.tcc_definition
      @other_tcc.save!
      @other_tcc.reload

      #Tcc com tcc_definition diferente do utilizado no scopo de testes,
      # como se fosse uma "turma" diferente
      @other_tcc_2            = Fabricate(:tcc_with_all)
      @other_tcc_2.orientador = @tcc_1.orientador
      @other_tcc_2.tutor      = @tcc_2.tutor

      @other_tcc_2.save!
      @other_tcc_2.reload

      @other_tcc_2_user = Authentication::User.new fake_lti_tp('student')
      @other_tcc_2_user.person    = @other_tcc_2.student
      page.set_rack_session(fake_lti_session_by_person(role_context, person_session, @tcc_1))
    end

    after(:each) do
      @tcc_1.destroy
      @tcc_2.destroy
      @tcc_3.destroy
      @other_tcc.destroy
      @other_tcc_2.destroy
    end

    context 'login as leader user' do
      let(:role_context) { 'urn:moodle:role/orientador' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:tcc) {@tcc_1}
      let(:person_session) { tcc.orientador }

      it 'show Tccs list' do
        visit instructor_admin_path
        expect(page).to have_content(I18n.t(:tcc_list))
        expect(page).to have_content(@tcc_1.student.name)
        expect(page).to have_content(@tcc_2.student.name)
        expect(page).to_not have_content(@tcc_3.student.name)
        expect(page).to_not have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end

    context 'login as admin user' do
      let(:role_context) { 'administrator' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}

      it 'show Tccs list' do
        visit instructor_admin_path
        expect(page).to have_content(I18n.t(:tcc_list))
        expect(page).to have_content(@tcc_1.student.name)
        expect(page).to have_content(@tcc_2.student.name)
        expect(page).to have_content(@tcc_3.student.name)
        expect(page).to have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end

    context 'login as AVEA coordinator' do
      let(:role_context) { 'urn:moodle:role/coordavea' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}

      it 'show Tccs list' do
        visit instructor_admin_path
        expect(page).to have_content(I18n.t(:tcc_list))
        expect(page).to have_content(@tcc_1.student.name)
        expect(page).to have_content(@tcc_2.student.name)
        expect(page).to have_content(@tcc_3.student.name)
        expect(page).to have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end

    context 'login as course coordinator' do
      let(:role_context) { 'urn:moodle:role/coordcurso' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}

      it 'show Tccs list' do
        visit instructor_admin_path
        expect(page).to have_content(I18n.t(:tcc_list))
        expect(page).to have_content(@tcc_1.student.name)
        expect(page).to have_content(@tcc_2.student.name)
        expect(page).to have_content(@tcc_3.student.name)
        expect(page).to have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end

    context 'login as tutor' do
      let(:role_context) { 'urn:moodle:role/td' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}

      it 'does not show Tccs list' do
        visit instructor_admin_path
        expect(page).to_not have_content(I18n.t(:tcc_list))
        expect(page).to_not have_content(@tcc_1.student.name)
        expect(page).to_not have_content(@tcc_2.student.name)
        expect(page).to_not have_content(@tcc_3.student.name)
        expect(page).to_not have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end

    context 'login as tutor coordinator' do
      let(:role_context) { 'urn:moodle:role/tutoria' }
      let(:lti_user) { Authentication::User.new fake_lti_tp(role_context) }
      let(:person_session) { lti_user.person }
      let(:tcc) {@tcc_1}

      it 'does not show Tccs list' do
        visit instructor_admin_path
        expect(page).to_not have_content(I18n.t(:tcc_list))
        expect(page).to_not have_content(@tcc_1.student.name)
        expect(page).to_not have_content(@tcc_2.student.name)
        expect(page).to_not have_content(@tcc_3.student.name)
        expect(page).to_not have_content(@other_tcc.student.name)
        expect(page).to_not have_content(@other_tcc_2.student.name)
      end
    end
  end
end
