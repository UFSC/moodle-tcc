require 'spec_helper'

describe ChapterPolicy do

  let (:admin) { Authentication::User.new fake_lti_tp('administrator') }
  let (:coordenador_AVEA) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea') }
  let (:coordenador_tutoria) { Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria') }
  let (:coordenador_curso) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso') }

  let (:other_user) { Authentication::User.new fake_lti_tp('student') }
  let (:other_leader) { Authentication::User.new fake_lti_tp('urn:moodle:role/orientador') }

  subject { ChapterPolicy }

  before(:all) do
    @tcc_1 = Fabricate(:tcc_with_all_comments)
    @tcc_1_user = Authentication::User.new fake_lti_tp('student')
    @tcc_1_leader = Authentication::User.new fake_lti_tp('urn:moodle:role/orientador')
    @tcc_1_tutor = Authentication::User.new fake_lti_tp('urn:moodle:role/td')

    @tcc_1_user.person    = @tcc_1.student
    @tcc_1_leader.person  = @tcc_1.orientador
    @tcc_1_tutor.person   = @tcc_1.tutor
    @tcc_1.save!
    @tcc_1.reload

  end

  after :all do
    @tcc_1.destroy
  end

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end


  context 'Na permissão de acesso verifica se na Action' do
    permissions :edit?, :save?, :update?, :create?, :empty? do
      context 'estudante pode editar seus dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.chapters.last)
        end
      end

      context 'outro estudante não pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.last)
        end
      end

      context 'orientador do TCC pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.chapters.last)
        end
      end

      context 'orientador de outro TCC não pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.last)
        end
      end

      context 'tutor do TCC pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.last)
        end
      end

      context 'admin do TCC pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_AVEA) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea') }
      context 'coordenador de AVEA pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_tutoria) { Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria') }
      context 'coordenador de tutoria do TCC não pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_curso) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso') }
      context 'coordenador do curso do TCC pode editar os dados do ' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(coordenador_curso, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(coordenador_curso, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(coordenador_curso, @tcc_1.chapters.last)
        end
      end

    end

    permissions :edit_comment? do
      context 'estudante não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(@tcc_1_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_user, @tcc_1.chapters.last)
        end
      end

      context 'outro estudante não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.last)
        end
      end

      context 'orientador do TCC pode editar os dados do ' do
        it 'capítulo Abstract' do
          @tcc_1.abstract.to_review
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          @tcc_1.chapters.first.to_review
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          @tcc_1.chapters.last.to_review
          expect(ChapterPolicy).to permit(@tcc_1_leader, @tcc_1.chapters.last)
        end
      end

      context 'orientador de outro TCC não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.last)
        end
      end

      context 'tutor do TCC não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.last)
        end
      end

      context 'admin do TCC não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(admin, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(admin, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(admin, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_AVEA) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea') }
      context 'coordenador de AVEA não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_AVEA, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_AVEA, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_AVEA, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_tutoria) { Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria') }
      context 'coordenador de tutoria do TCC não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_curso) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso') }
      context 'coordenador do curso do TCC não pode editar os comentários' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.chapters.last)
        end
      end
    end

    permissions :execute_import? do
      context 'estudante pode importar de seu Tcc o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(@tcc_1_user, @tcc_1.chapters.last)
        end
      end

      context 'outro estudante não pode importar de outro Tcc o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_user, @tcc_1.chapters.last)
        end
      end
      context 'orientador do TCC não pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(@tcc_1_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_leader, @tcc_1.chapters.last)
        end
      end

      context 'orientador de outro TCC pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(other_leader, @tcc_1.chapters.last)
        end
      end

      context 'tutor do TCC não pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(@tcc_1_tutor, @tcc_1.chapters.last)
        end
      end

      context 'admin do TCC pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(admin, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_AVEA) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordavea') }
      context 'coordenador de AVEA pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).to permit(coordenador_AVEA, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_tutoria) { Authentication::User.new fake_lti_tp('urn:moodle:role/tutoria') }
      context 'coordenador de tutoria do TCC não pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_tutoria, @tcc_1.chapters.last)
        end
      end

      #let (:coordenador_curso) { Authentication::User.new fake_lti_tp('urn:moodle:role/coordcurso') }
      context 'coordenador do curso do TCC não pode importar o' do
        it 'capítulo Abstract' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.abstract)
        end
        it 'primeiro capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.chapters.first)
        end
        it 'último capítulo' do
          expect(ChapterPolicy).not_to permit(coordenador_curso, @tcc_1.chapters.last)
        end
      end
    end

  end
end
