require 'spec_helper'

describe TccPolicy do

  let (:current_user) { Authentication::User.new fake_lti_tool_provider('student') }
  let (:other_user) { Authentication::User.new fake_lti_tool_provider('student') }
  let (:admin) { Authentication::User.new fake_lti_tool_provider('administrator') }
  let (:coordenador_AVEA) { Authentication::User.new fake_lti_tool_provider('urn:moodle:role/coordavea') }
  let (:coordenador_tutoria) { Authentication::User.new fake_lti_tool_provider('urn:moodle:role/tutoria') }
  let (:coordenador_curso) { Authentication::User.new fake_lti_tool_provider('urn:moodle:role/coordcurso') }

  subject { TccPolicy }

  before(:all) do
    @tcc_1 = Fabricate(:tcc_with_all)
    @tcc_1_user = Authentication::User.new fake_lti_tool_provider('student')
    @tcc_1_leader = Authentication::User.new fake_lti_tool_provider('urn:moodle:role/orientador')
    @tcc_1_tutor = Authentication::User.new fake_lti_tool_provider('urn:moodle:role/td')

    @tcc_1_user.person    = @tcc_1.student
    @tcc_1_leader.person  = @tcc_1.orientador
    @tcc_1_tutor.person   = @tcc_1.tutor
    @tcc_1.save!
    @tcc_1.reload

    @tcc_2 = Fabricate(:tcc_with_all)
    @tcc_2.tcc_definition = @tcc_1.tcc_definition
    @tcc_2_user = Authentication::User.new fake_lti_tool_provider('student')
    @tcc_2_tutor = Authentication::User.new fake_lti_tool_provider('urn:moodle:role/td')

    @tcc_2_user.person    = @tcc_2.student
    @tcc_2.orientador     = @tcc_1.orientador
    @tcc_2_tutor.person   = @tcc_2.tutor
    @tcc_2.save!
    @tcc_2.reload

    @tcc_3 = Fabricate(:tcc_with_all)
    @tcc_3.tcc_definition = @tcc_1.tcc_definition
    @tcc_3_user = Authentication::User.new fake_lti_tool_provider('student')
    @tcc_3_leader = Authentication::User.new fake_lti_tool_provider('urn:moodle:role/orientador')

    @tcc_3_user.person    = @tcc_3.student
    @tcc_3_leader.person  = @tcc_3.orientador
    @tcc_3.tutor          = @tcc_1.tutor
    @tcc_3.save!
    @tcc_3.reload

    @other_tcc = Fabricate(:tcc_with_all)
    @other_tcc.tcc_definition = @tcc_1.tcc_definition
    @other_tcc.save!
    @other_tcc.reload
  end

  after :all do
    @tcc_1.destroy
    @tcc_2.destroy
    @tcc_3.destroy
    @other_tcc.destroy
  end

  context 'Na permissão de acesso verifica se na Action' do
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
        #expect(TccPolicy).to permit(@tcc_1_tutor, @tcc_1)
        expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_1)
        expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_3)
        expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_2)
      end

      it 'tutor não pode ver quem não é seu estudante' do
        expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_1)
        expect(TccPolicy).not_to permit(@tcc_2_tutor, @tcc_3)
        expect(TccPolicy).not_to permit(@tcc_1_tutor, @tcc_2)
        expect(TccPolicy).not_to permit(@tcc_2_tutor, @other_tcc)
        expect(TccPolicy).not_to permit(@tcc_1_tutor, @other_tcc)
      end

      context "admin" do
        let (:user) { admin }
        it 'pode ver todos TCCs' do
          expect(TccPolicy).to permit(admin, @tcc_1)
          expect(TccPolicy).to permit(admin, @tcc_2)
          expect(TccPolicy).to permit(admin, @tcc_3)
          expect(TccPolicy).to permit(admin, @other_tcc)
        end
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
        #expect(TccPolicy).to permit(coordenador_tutoria, @tcc_1)
        expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_1)
        expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_2)
        expect(TccPolicy).not_to permit(coordenador_tutoria, @tcc_3)
        expect(TccPolicy).not_to permit(coordenador_tutoria, @other_tcc)
      end
    end

    # Verifica se pode exibir a lista de TCCs
    permissions :show_scope? do
      it 'admin pode ver a lista de TCCs' do
        expect(TccPolicy).to permit(admin)
      end

      it 'coordenador de AVEA pode ver a lista de TCCs' do
        expect(TccPolicy).to permit(coordenador_AVEA)
      end

      it 'coordenador de tutoria pode ver a lista de TCCs' do
        #expect(TccPolicy).to permit(coordenador_tutoria)
        expect(TccPolicy).not_to permit(coordenador_tutoria)
      end

      it 'coordenador de curso pode ver a lista de TCCs' do
        expect(TccPolicy).to permit(coordenador_curso)
      end

      it 'orientador pode ver a lista de TCCs' do
        expect(TccPolicy).to permit(@tcc_1_leader)
        expect(TccPolicy).to permit(@tcc_3_leader)
      end

      it 'tutor pode ver a lista de TCCs' do
        #expect(TccPolicy).to permit(@tcc_1_tutor)
        expect(TccPolicy).not_to permit(@tcc_1_tutor)
        expect(TccPolicy).not_to permit(@tcc_2_tutor)
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

  context 'Na política do TCC: [' do
    let(:scope) { Tcc.includes(:student, chapters: [:chapter_definition]).
        where(tcc_definition_id: @tcc_1.tcc_definition.id) }
    subject(:policy_scope) { TccPolicy::Scope.new(user, scope).resolve }

    before :all do
      #Tcc com tcc_definition diferente do utilizado no scopo de testes,
      # como se fosse uma "turma" diferente
      @other_tcc_2            = Fabricate(:tcc_with_all)
      @other_tcc_2.orientador = @tcc_1.orientador
      @other_tcc_2.tutor      = @tcc_2.tutor

      @other_tcc_2.save!
      @other_tcc_2.reload

      @other_tcc_2_user = Authentication::User.new fake_lti_tool_provider('student')
      @other_tcc_2_user.person    = @other_tcc_2.student

    end

    after :all do
      @other_tcc_2.destroy
    end

    permissions '.scope' do
      context '] verifica se o usuário estudante' do
        let(:user)  { @tcc_1_user }
        it 'pode ver o seu tcc 1' do
          expect(policy_scope).to include(@tcc_1)
        end

        it 'nao pode ver o tcc de outro estudante 2' do
          expect(policy_scope).not_to include(@tcc_2)
        end

        it 'nao pode ver o tcc de outro estudante 3' do
          expect(policy_scope).not_to include(@tcc_3)
        end

        it 'nao pode ver o tcc de outro estudante 4' do
          expect(policy_scope).not_to include(@other_tcc)
        end

        it 'pode ver o seu tcc 2' do
          expect(Pundit.policy_scope(@tcc_2_user, scope)).to include(@tcc_2)
        end

        it 'pode ver o seu tcc 3' do
          expect(Pundit.policy_scope(@tcc_3_user, scope)).to include(@tcc_3)
        end
      end

      context '] verifica se o usuário com ViewAll[' do
        context 'admin' do
          let (:user) { admin }
          it '] pode ver todos os TCCs' do
            expect(policy_scope).to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
          end

          it '] não pode ver os TCCs de outro curso' do
            expect(policy_scope).not_to include(@other_tcc_2)
          end
        end

        context 'coordenador de AVEA' do
          let (:user) { coordenador_AVEA }
          it '] pode ver todos os TCCs' do
            expect(policy_scope).to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
          end

          it '] não pode ver os TCCs de outro curso' do
            expect(policy_scope).not_to include(@other_tcc_2)
          end

        end

        context 'coordenador do curso' do
          let (:user) { coordenador_curso }
          it '] pode ver todos os TCCs' do
            expect(policy_scope).to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
          end

          it '] não pode ver os TCCs de outro curso' do
            expect(policy_scope).not_to include(@other_tcc_2)
          end
        end

        context 'coordenador de tutoria' do
          let (:user) { coordenador_tutoria }
          it '] pode ver todos os TCCs' do
            #expect(policy_scope).to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
          end

          it '] não pode ver os TCCs de outro curso' do
            expect(policy_scope).not_to include(@other_tcc_2)
          end

        end
      end

      context '] verifica se o usuário [' do
        context 'orientador' do
          let (:user) {  @tcc_1_leader }
          it '] pode ver todos os TCCs de seus estudantes' do
            expect(policy_scope).to include(@tcc_1, @tcc_2)
          end

          it '] não pode ver todos os TCCs de outros orientadores' do
            expect(policy_scope).not_to include(@tcc_3, @other_tcc, @other_tcc_2)
          end
        end

        context 'tutor' do
          let (:user) { @tcc_1_tutor }
          it '] pode ver todos os TCCs de seus estudantes' do
            #expect(policy_scope).to include(@tcc_1, @tcc_3)
            expect(policy_scope).not_to include(@tcc_1, @tcc_3)
          end

          it '] não pode ver todos os TCCs de outros orientadores' do
            expect(policy_scope).not_to include(@tcc_2, @other_tcc, @other_tcc_2)
          end
        end
      end

      context '] em outra turma [' do
        let(:scope) { Tcc.includes(:student, chapters: [:chapter_definition]).
            where(tcc_definition_id: @other_tcc_2.tcc_definition.id) }
        subject(:policy_scope) { TccPolicy::Scope.new(user, scope).resolve }

        context '] verifica se o usuário estudante' do
          let(:user)  { @other_tcc_2_user }
          it 'pode ver o seu tcc 2' do
            expect(policy_scope).to include(@other_tcc_2)
          end

          it 'não pode ver o seu tcc de outro estudante' do
            expect(policy_scope).not_to include(@tcc_1)
          end

          it 'nao pode ver o tcc de outro estudante 2' do
            expect(policy_scope).not_to include(@tcc_2)
          end

          it 'nao pode ver o tcc de outro estudante 3' do
            expect(policy_scope).not_to include(@tcc_3)
          end

          it 'nao pode ver o tcc de outro estudante 4' do
            expect(policy_scope).not_to include(@other_tcc)
          end
        end

        context '] verifica se o usuário com ViewAll[' do
          context 'admin' do
            let (:user) { admin }
            it '] pode ver todos os TCCs' do
              expect(policy_scope).to include(@other_tcc_2)
            end

            it '] não pode ver os TCCs de outro curso' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end
          end

          context 'coordenador de AVEA' do
            let (:user) { coordenador_AVEA }
            it '] pode ver todos os TCCs' do
              expect(policy_scope).to include(@other_tcc_2)
            end

            it '] não pode ver os TCCs de outro curso' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end

          end

          context 'coordenador do curso' do
            let (:user) { coordenador_curso }
            it '] pode ver todos os TCCs' do
              expect(policy_scope).to include(@other_tcc_2)
            end

            it '] não pode ver os TCCs de outro curso' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end
          end

          context 'coordenador de tutoria' do
            let (:user) { coordenador_tutoria }
            it '] pode ver todos os TCCs' do
              #expect(policy_scope).not_to include(@other_tcc_2)
              expect(policy_scope).not_to include(@other_tcc_2)
            end

            it '] não pode ver os TCCs de outro curso' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end

          end
        end

        context '] verifica se o usuário [' do
          context 'orientador' do
            let (:user) {  @tcc_1_leader }
            it '] pode ver todos os TCCs de seus estudantes' do
              expect(policy_scope).to include(@other_tcc_2)
            end

            it '] não pode ver todos os TCCs de outros orientadores' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end
          end

          context 'tutor' do
            let (:user) { @tcc_2_tutor }
            it '] pode ver todos os TCCs de seus estudantes' do
              #expect(policy_scope).to include(@other_tcc_2)
              expect(policy_scope).not_to include(@other_tcc_2)
            end

            it '] não pode ver todos os TCCs de outros tutores' do
              expect(policy_scope).not_to include(@tcc_1, @tcc_2, @tcc_3, @other_tcc)
            end
          end
        end
      end # escopo de outra turma
    end #scope
  end #politica do tcc
end