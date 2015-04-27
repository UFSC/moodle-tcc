#encoding: utf-8
require 'spec_helper'

shared_context 'test show_graded' do
  it 'should work show_graded_all' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            nil,
            nil
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to have_content(@tcc_1.student.name)
    expect(page).to have_content(@tcc_2.student.name)
    expect(page).to have_content(@tcc_3.student.name)

  end

  it 'should work show_graded_after' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            Date.today.strftime("%Y-%m-%d"),
            nil
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to have_content(@tcc_1.student.name)
    expect(page).to_not have_content(@tcc_2.student.name)
    expect(page).to have_content(@tcc_3.student.name)

  end

  it 'should work show_graded_before' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            nil,
            Date.today.strftime("%Y-%m-%d")
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to have_content(@tcc_1.student.name)
    expect(page).to have_content(@tcc_2.student.name)
    expect(page).to_not have_content(@tcc_3.student.name)

  end

  it 'should work show_graded_between' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            (Date.today - 1.day).strftime("%Y-%m-%d"),
            (Date.today + 1.day).strftime("%Y-%m-%d")
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to have_content(@tcc_1.student.name)
    expect(page).to_not have_content(@tcc_2.student.name)
    expect(page).to_not have_content(@tcc_3.student.name)

  end
end

shared_context 'test show_graded for leader' do
  it 'should work show_graded_all' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            nil,
            nil
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to_not have_content(@tcc_11.student.name)
    expect(page).to_not have_content(@tcc_12.student.name)
    expect(page).to_not have_content(@tcc_13.student.name)

  end

  it 'should work show_graded_after' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            Date.today.strftime("%Y-%m-%d"),
            nil
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to_not have_content(@tcc_11.student.name)
    expect(page).to_not have_content(@tcc_12.student.name)
    expect(page).to_not have_content(@tcc_13.student.name)

  end

  it 'should work show_graded_before' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            nil,
            Date.today.strftime("%Y-%m-%d")
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to_not have_content(@tcc_11.student.name)
    expect(page).to_not have_content(@tcc_12.student.name)
    expect(page).to_not have_content(@tcc_13.student.name)
  end

  it 'should work show_graded_between' do
    page.set_rack_session(
        fake_lti_session_by_person_graded(
            role_context,
            person_session,
            @tcc_1,
            (Date.today - 1.day).strftime("%Y-%m-%d"),
            (Date.today + 1.day).strftime("%Y-%m-%d")
        )
    )

    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')

    expect(page).to_not have_content(@tcc_11.student.name)
    expect(page).to_not have_content(@tcc_12.student.name)
    expect(page).to_not have_content(@tcc_13.student.name)
  end
end

shared_context 'should render tcc listing' do
  it 'should work with moodle' do
    page.set_rack_session(fake_lti_session(role_context))
    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
  end

  it 'if starting type is tcc' do
    page.set_rack_session(fake_lti_session(role_context))
    visit instructor_admin_path

    expect(page.current_path).not_to eq(access_denied_path)
    expect(page).to have_content('Lista de TCCs')
  end

end

describe 'InstructorAdmin' do
  describe 'GET /instructor_admin' do

    context 'for AVEA context' do
      let(:role_context) { 'urn:moodle:role/coordavea' }

      it_behaves_like 'should render tcc listing'
    end

    context 'for coordcurso context' do
      let(:role_context) { 'urn:moodle:role/coordcurso' }

      it_behaves_like 'should render tcc listing'
    end

    context 'for ADMIN context' do
      let(:role_context) { 'administrator' }

      it_behaves_like 'should render tcc listing'
    end

    context 'for leader context' do
      let(:role_context) { 'urn:moodle:role/orientador' }

      it_behaves_like 'should render tcc listing'
    end

    it 'should not work without moodle' do
      get instructor_admin_path
      expect(response).to render_template('errors/unauthorized')
    end

    context 'check for show_graded param' do

      before(:all) do
        @tcc_1 = Fabricate(:tcc_with_grade)

        @tcc_2 = Fabricate(:tcc_with_grade)
        @tcc_2.tcc_definition = @tcc_1.tcc_definition
        @tcc_2.orientador = @tcc_1.orientador
        @tcc_2.grade_updated_at = Date.today - 2.days
        @tcc_2.save!
        @tcc_2.reload

        @tcc_3 = Fabricate(:tcc_with_grade)
        @tcc_3.tcc_definition = @tcc_1.tcc_definition
        @tcc_3.orientador = @tcc_1.orientador
        @tcc_3.grade_updated_at = Date.today + 2.days
        @tcc_3.save!
        @tcc_3.reload
      end

      after(:all) do
        @tcc_1.destroy
        @tcc_2.destroy
        @tcc_3.destroy
      end

      context 'to role AVEA' do
        let(:role_context) { 'urn:moodle:role/coordavea' }
        let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
        let(:tcc) { @tcc_1 }
        let(:person_session) { lti_user.person }

        it_behaves_like 'test show_graded'
      end

      context 'to role administrator' do
        let(:role_context) { 'administrator' }
        let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
        let(:tcc) { @tcc_1 }
        let(:person_session) { lti_user.person }

        it_behaves_like 'test show_graded'
      end

      context 'to role coordcurso' do
        let(:role_context) { 'urn:moodle:role/coordcurso' }
        let(:lti_user) { Authentication::User.new fake_lti_tool_provider(role_context) }
        let(:tcc) { @tcc_1 }
        let(:person_session) { lti_user.person }

        it_behaves_like 'test show_graded'
      end

      context 'to role orientador' do
        let(:role_context) { 'urn:moodle:role/orientador' }
        let(:tcc) { @tcc_1 }
        let(:person_session) { tcc.orientador }

        before(:all) do

          @tcc_11 = Fabricate(:tcc_with_grade)

          @tcc_12 = Fabricate(:tcc_with_grade)
          @tcc_12.tcc_definition = @tcc_1.tcc_definition
          @tcc_12.orientador = @tcc_11.orientador
          @tcc_12.grade_updated_at = Date.today - 2.days
          @tcc_12.save!
          @tcc_12.reload

          @tcc_13 = Fabricate(:tcc_with_grade)
          @tcc_13.tcc_definition = @tcc_11.tcc_definition
          @tcc_13.orientador = @tcc_11.orientador
          @tcc_13.grade_updated_at = Date.today + 2.days
          @tcc_13.save!
          @tcc_13.reload
        end

        after(:all) do
          @tcc_11.destroy
          @tcc_12.destroy
          @tcc_13.destroy
        end

        it_behaves_like 'test show_graded'

        it_behaves_like 'test show_graded for leader'
      end
    end
  end
end
