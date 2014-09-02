class PersonDecorator < Draper::Decorator
  delegate_all

  # Nome do estudante
  # @return [String] nome do estudante sem a matrícula (201x...)
  def name
    object.name.gsub(/ \([0-9].*\)/, '')
  end

end