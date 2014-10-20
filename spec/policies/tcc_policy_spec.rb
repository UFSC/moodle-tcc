require 'spec_helper'

describe TccPolicy do

  let (:current_user) { Authentication::User.new fake_lti_tp('student') }
  let (:other_user) { Authentication::User.new fake_lti_tp('student') }
  let (:admin) { Authentication::User.new fake_lti_tp('administrator') }
  let (:coordenador_AVEA) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea') }
  let (:coordenador_tutoria) { Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria') }
  let (:coordenador_curso) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso') }

  subject { TccPolicy }

  before(:all) do
    @tcc_1 = Fabricate(:tcc_memory)
    @tcc_1_user = Authentication::User.new fake_lti_tp('student')
    @tcc_1_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
    @tcc_1_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

    @tcc_1_user.person    = @tcc_1.student
    @tcc_1_leader.person  = @tcc_1.orientador
    @tcc_1_tutor.person   = @tcc_1.tutor

    @tcc_2 = Fabricate(:tcc_memory)
    @tcc_2_user = Authentication::User.new fake_lti_tp('student')
    @tcc_2_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
    @tcc_2_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

    @tcc_2_user.person    = @tcc_2.student
    @tcc_2.orientador     = @tcc_1.orientador
    @tcc_2_tutor.person   = @tcc_2.tutor

    @tcc_3 = Fabricate(:tcc_memory)
    @tcc_3_user = Authentication::User.new fake_lti_tp('student')
    @tcc_3_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
    @tcc_3_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

    @tcc_3_user.person    = @tcc_3.student
    @tcc_3_leader.person  = @tcc_3.orientador
    @tcc_3.tutor          = @tcc_1.tutor

    @other_tcc = Fabricate(:tcc_memory)
  end

  permissions :show? do
    it 'student show their TCC' do
      expect(TccPolicy).to permit(@tcc_1_user, @tcc_1)
      expect(TccPolicy).to permit(@tcc_2_user, @tcc_2)
      expect(TccPolicy).to permit(@tcc_3_user, @tcc_3)
    end

    it 'prevents an user from accessing data from another' do
      expect(TccPolicy).not_to permit(@tcc_1_user, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_1_user, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_2_user, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_2_user, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_3_user, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_3_user, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_1_user, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_2_user, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_3_user, @other_tcc)
    end

    it 'orientador pode ver seu estudante' do
      expect(TccPolicy).to permit(@tcc_1_leader, @tcc_1)
      expect(TccPolicy).to permit(@tcc_1_leader, @tcc_2)
      expect(TccPolicy).to permit(@tcc_3_leader, @tcc_3)
    end

    it 'orientador não pode ver quem não é seu estudante' do
      expect(TccPolicy).not_to permit(@tcc_3_leader, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_1_leader, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_1_leader, @other_tcc)
    end

    it 'turor pode ver seu estudante' do
      expect(TccPolicy).to permit(@tcc_1_tutor, @tcc_1)
      expect(TccPolicy).to permit(@tcc_1_tutor, @tcc_3)
      expect(TccPolicy).to permit(@tcc_2_tutor, @tcc_2)
    end

    it 'tutor não pode ver quem não é seu estudante' do
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @other_tcc)
    end

    it 'admin pode ver todos TCCs' do
      expect(TccPolicy).to permit(admin, @tcc_1)
      expect(TccPolicy).to permit(admin, @tcc_2)
      expect(TccPolicy).to permit(admin, @tcc_3)
      expect(TccPolicy).to permit(admin, @other_tcc)
    end

    it 'coordenador de AVEA pode ver todos TCCs' do
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_1)
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_2)
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_3)
      expect(TccPolicy).to permit(coordenador_AVEA, @other_tcc)
    end

    it 'coordenador do Curso pode ver todos TCCs' do
      expect(TccPolicy).to permit(coordenador_curso, @tcc_1)
      expect(TccPolicy).to permit(coordenador_curso, @tcc_2)
      expect(TccPolicy).to permit(coordenador_curso, @tcc_3)
      expect(TccPolicy).to permit(coordenador_curso, @other_tcc)
    end

    it 'coordenador de Tutoria pode ver todos TCCs' do
      expect(TccPolicy).to permit(coordenador_tutoria, @tcc_1)
      expect(TccPolicy).to permit(coordenador_tutoria, @tcc_2)
      expect(TccPolicy).to permit(coordenador_tutoria, @tcc_3)
      expect(TccPolicy).to permit(coordenador_tutoria, @other_tcc)
    end
  end

  permissions :show_scope? do
    #(user.view_all? || user.instructor?)

    it 'admin pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(admin)
    end

    it 'coordenador de AVEA pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(coordenador_AVEA)
    end

    it 'coordenador de tutoria pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(coordenador_tutoria)
    end

    it 'coordenador de curso pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(coordenador_curso)
    end

    it 'orientador pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(@tcc_1_leader)
      expect(TccPolicy).to permit(@tcc_3_leader)
    end

    it 'tutor pode ver a lista de TCCs' do
      expect(TccPolicy).to permit(@tcc_1_tutor)
      expect(TccPolicy).to permit(@tcc_2_tutor)
    end

    it 'estudante não pode ver a lista de TCCs' do
      expect(TccPolicy).not_to permit(@tcc_1_user)
      expect(TccPolicy).not_to permit(@tcc_2_user)
      expect(TccPolicy).not_to permit(@tcc_3_user)
      expect(TccPolicy).not_to permit(current_user)
      expect(TccPolicy).not_to permit(other_user)
    end
  end

end