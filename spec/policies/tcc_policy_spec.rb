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

  after :all do
    @tcc_1.destroy
    @tcc_2.destroy
    @tcc_3.destroy
    @other_tcc.destroy
  end

  permissions :show? do
    it 'estudante pode ver seus dados' do
      expect(TccPolicy).to permit(@tcc_1_user, @tcc_1)
      expect(TccPolicy).to permit(@tcc_2_user, @tcc_2)
      expect(TccPolicy).to permit(@tcc_3_user, @tcc_3)
    end

    it 'estudante não pode ver os dados de outro estudante' do
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

  # Verifica se pode exibir a lista de TCCs
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

  # Verifica se pode editar a data de defesa
  permissions :edit_defense_date? do
    #user.coordenador_avea? || user.admin?

    it 'admin pode editar a data de defesa' do
      expect(TccPolicy).to permit(admin)
    end

    it 'coordenador de AVEA pode editar a data de defesa' do
      expect(TccPolicy).to permit(coordenador_AVEA)
    end

    it 'coordenador de tutoria não pode editar a data de defesa' do
      expect(TccPolicy).not_to permit(coordenador_tutoria)
    end

    it 'coordenador de curso não pode editar a data de defesa' do
      expect(TccPolicy).not_to permit(coordenador_curso)
    end

    it 'orientador não pode editar a data de defesa' do
      expect(TccPolicy).not_to permit(@tcc_1_leader)
      expect(TccPolicy).not_to permit(@tcc_3_leader)
    end

    it 'tutor não pode editar a data de defesa' do
      expect(TccPolicy).not_to permit(@tcc_1_tutor)
      expect(TccPolicy).not_to permit(@tcc_2_tutor)
    end

    it 'estudante não pode editar a data de defesa' do
      expect(TccPolicy).not_to permit(@tcc_1_user)
      expect(TccPolicy).not_to permit(@tcc_2_user)
      expect(TccPolicy).not_to permit(@tcc_3_user)
      expect(TccPolicy).not_to permit(current_user)
      expect(TccPolicy).not_to permit(other_user)
    end

  end

  # Apresenta as tabs somente para o estudante, pois para os outros o acesso aos itens do TCC será pela lista
  permissions :show_tabs_header? do
    # user.student?

    it 'admin não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(admin)
    end

    it 'coordenador de AVEA não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(coordenador_AVEA)
    end

    it 'coordenador de tutoria não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(coordenador_tutoria)
    end

    it 'coordenador de curso não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(coordenador_curso)
    end

    it 'orientador não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(@tcc_1_leader)
      expect(TccPolicy).not_to permit(@tcc_3_leader)
    end

    it 'tutor não pode ver as abas de capítulos' do
      expect(TccPolicy).not_to permit(@tcc_1_tutor)
      expect(TccPolicy).not_to permit(@tcc_2_tutor)
    end

    it 'estudante pode ver as abas de capítulos' do
      expect(TccPolicy).to permit(@tcc_1_user)
      expect(TccPolicy).to permit(@tcc_2_user)
      expect(TccPolicy).to permit(@tcc_3_user)
      expect(TccPolicy).to permit(current_user)
      expect(TccPolicy).to permit(other_user)
    end
  end

  # Identifica o nome do estudante caso as telas não sejam abertas por abas
  permissions :show_student? do
    # !show_tabs_header?

    it 'admin pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(admin)
    end

    it 'coordenador de AVEA pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(coordenador_AVEA)
    end

    it 'coordenador de tutoria pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(coordenador_tutoria)
    end

    it 'coordenador de curso pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(coordenador_curso)
    end

    it 'orientador pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(@tcc_1_leader)
      expect(TccPolicy).to permit(@tcc_3_leader)
    end

    it 'tutor pode mostrar o nome do estudante' do
      expect(TccPolicy).to permit(@tcc_1_tutor)
      expect(TccPolicy).to permit(@tcc_2_tutor)
    end

    it 'estudante não pode mostrar o nome do estudante' do
      expect(TccPolicy).not_to permit(@tcc_1_user)
      expect(TccPolicy).not_to permit(@tcc_2_user)
      expect(TccPolicy).not_to permit(@tcc_3_user)
      expect(TccPolicy).not_to permit(current_user)
      expect(TccPolicy).not_to permit(other_user)
    end
  end

  # Verifica se pode apresentar a ferramenta de Nomes Composto (na bibliografia)
  permissions :show_compound_names? do
    # (user.coordenador_avea? || user.admin?)

    it 'admin pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).to permit(admin)
    end

    it 'coordenador de AVEA pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).to permit(coordenador_AVEA)
    end

    it 'coordenador de tutoria não pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).not_to permit(coordenador_tutoria)
    end

    it 'coordenador de curso não pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).not_to permit(coordenador_curso)
    end

    it 'orientador não pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).not_to permit(@tcc_1_leader)
      expect(TccPolicy).not_to permit(@tcc_3_leader)
    end

    it 'tutor não pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).not_to permit(@tcc_1_tutor)
      expect(TccPolicy).not_to permit(@tcc_2_tutor)
    end

    it 'estudante não pode mostrar a ferramenta de Nomes Composto' do
      expect(TccPolicy).not_to permit(@tcc_1_user)
      expect(TccPolicy).not_to permit(@tcc_2_user)
      expect(TccPolicy).not_to permit(@tcc_3_user)
      expect(TccPolicy).not_to permit(current_user)
      expect(TccPolicy).not_to permit(other_user)
    end

  end

  # Verifica se pode importar os capítulos das atividades do Moodle
  permissions :import_chapters? do
    #if user.student?
    #  return record.student_id == user.person.id
    #end
    #show_compound_names? # (user.coordenador_avea? || user.admin?)
    it 'estudante pode importar os capitulos de seu TCC' do
      expect(TccPolicy).to permit(@tcc_1_user, @tcc_1)
      expect(TccPolicy).to permit(@tcc_2_user, @tcc_2)
      expect(TccPolicy).to permit(@tcc_3_user, @tcc_3)
    end

    it 'estudante não pode importar os capitulos do TCC de outro estudante' do
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

    it 'coordenador de AVEA pode importar os capitulos do TCC de outro estudante' do
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_1)
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_2)
      expect(TccPolicy).to permit(coordenador_AVEA, @tcc_3)
      expect(TccPolicy).to permit(coordenador_AVEA, @other_tcc)
    end

    it 'coordenador do Curso não pode importar os capitulos do TCC' do
      expect(TccPolicy).not_to permit(coordenador_curso, @tcc_1)
      expect(TccPolicy).not_to permit(coordenador_curso, @tcc_2)
      expect(TccPolicy).not_to permit(coordenador_curso, @tcc_3)
      expect(TccPolicy).not_to permit(coordenador_curso, @other_tcc)
    end

    it 'coordenador de Tutoria não pode importar os capitulos do TCC' do
      expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_1)
      expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_2)
      expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_3)
      expect(TccPolicy).not_to permit(coordenador_tutoria, @other_tcc)
    end

    it 'orientador não pode importar os capitulos do TCC' do
      expect(TccPolicy).not_to permit(@tcc_1_leader, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_1_leader, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_1_leader, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_1_leader, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_3_leader, @other_tcc)
    end

    it 'tutor não pode importar os capitulos do TCC' do
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_1_tutor, @other_tcc)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_1)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_2)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_3)
      expect(TccPolicy).not_to permit(@tcc_2_tutor, @other_tcc)
    end
  end
end