class ChapterPolicy < ApplicationPolicy

  def show?
    false
  end

  def edit?
    Pundit.policy(@user, @record.tcc).edit?
  end

  def create?
    Pundit.policy(@user, @record.tcc).create?
  end

  def update?
    Pundit.policy(@user, @record.tcc).update?
  end

  def save?
    Pundit.policy(@user, @record.tcc).save?
  end

  def empty?
    Pundit.policy(@user, @record.tcc).show?
  end

  def execute_import?
    Pundit.policy(@user, @record.tcc).import_chapters?
  end

  def must_import?
    @record.empty? && @record.chapter_definition.remote_text?
  end

  def can_import?
    # As seguintes condições precisam ser preenchidas para que o texto possa ser importado:
    # - O conteúdo do capítulo precisa estar vazio ou em branco
    # - O chapter_definition precisa ter uma referência para uma atividade remota (coursemodule_id)
    # - O status do envio dessa atividade remota tem que estar marcada como "submitted" (removida essa condição)
    # Conforme #7530 - Permitir que a importação do texto on-line seja apenas quando tiver nota
    if must_import?
      remote = MoodleAPI::MoodleOnlineText.new
      olt_grade = remote.fetch_online_text_grade(@record.tcc.student.moodle_id,
                                                 @record.chapter_definition.coursemodule_id)
      return (!olt_grade.nil? && olt_grade != false && olt_grade >= 0)
    end
    false
  end

  def edit_content?
    can_edit = Pundit.policy(@user, @record.tcc).show?
    if can_edit
      if user.orientador?
        return (%w(review).include?(record.state))
      elsif user.student?
        return (%w(draft empty).include?(record.state))
      elsif user.view_all?
        return (%w(review).include?(record.state))
      end
    end
    false
  end

  def edit_comment?
    if user.orientador?
      return (record.tcc.orientador.id == user.person.id) && edit_content?
    end
  end

  def can_send_to_review?
    can_show = Pundit.policy(@user, @record.tcc).show?
    if can_show
      return user.student? && (%w(draft empty).include?(record.state))
    end
    false
  end

  def can_send_to_draft_done?
    can_show = Pundit.policy(@user, @record.tcc).show?
    if can_show
      return (user.orientador? || user.view_all?) && record.state.eql?(:review.to_s)
    end
    false
  end

  def can_send_to_review_admin?
    can_show = Pundit.policy(@user, @record.tcc).show_compound_names? &&
        (%w(draft empty done).include?(record.state))
    can_show
  end

  def can_send_to_draft_admin?
    can_show = Pundit.policy(@user, @record.tcc).show_compound_names? &&
        (%w(done).include?(record.state))
    can_show
  end

  def can_send_to_done?
    # verifica se há condições mínimas para a aprovação do capítulo
    true
  end

  def must_verify_references?
    begin
      must_verify = @record.chapter_definition.verify_references
    rescue
      must_verify = false
    end
    must_verify
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
