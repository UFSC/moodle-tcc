class GenericReferenceDecorator < Draper::Decorator
  delegate_all

  # Redefinindo para as views que utilizam .class não obterem 'GenericReferenceDecorator'
  def class
    object.class
  end

  def direct_et_al
    "(#{first_author.split(' ').last.upcase} et al., #{year})"
  end

  def direct_citation
    # Pequena diferença de nomes nos models, talvez seja boa ideia considerar a troca para igualar
    if object.respond_to? :et_all
      return direct_et_al if et_all
    elsif object.respond_to? :et_al_part
      return direct_et_al if et_al_part
    end

    authors = "#{first_author.split(' ').last.upcase}"

    unless second_author.nil? || second_author.blank?
      lastname = UnicodeUtils.upcase(second_author.split(' ').last)
      authors = "#{authors}; #{lastname}"
    end

    unless third_author.nil? || third_author.blank?
      lastname = UnicodeUtils.upcase(third_author.split(' ').last)
      authors = "#{authors}; #{lastname}"
    end

    "(#{authors}, #{year})"
  end

  def indirect_et_al
    "#{UnicodeUtils.titlecase(first_author.split(' ').last)} et al. (#{year})"
  end

  def indirect_citation
    if object.respond_to? :et_all
      return indirect_et_al if et_all
    elsif object.respond_to? :et_al_part
      return indirect_et_al if et_al_part
    end

    elements = Array.new
    get_all_authors.each do |author|
      unless author.nil? || author.blank?
        elements << UnicodeUtils.titlecase(author.split(' ').last)
      end
    end
    "#{elements.to_sentence} (#{year})"
  end

  def get_all_authors
    [first_author, second_author, third_author]
  end


end
