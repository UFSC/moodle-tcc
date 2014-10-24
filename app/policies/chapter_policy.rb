class ChapterPolicy < ApplicationPolicy

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
    # - O status do envio dessa atividade remota tem que estar marcada como "submitted"
    #TODO: --  e com nota
    if must_import?
      remote = MoodleAPI::MoodleOnlineText.new
      status = remote.fetch_online_text_status(@record.tcc.student.moodle_id,
                                               @record.chapter_definition.coursemodule_id)
      return (status == 'submitted')
    end
    false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
