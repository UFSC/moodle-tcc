class GenericReferenceDecorator < Draper::Decorator
  delegate_all

  def direct_et_al
    "(#{citation_author(first_author)} et al., #{year})"
  end

  def direct_citation
    # Pequena diferença de nomes nos models, talvez seja boa ide  ia considerar a troca para igualar
    if object.respond_to? :et_all
      return direct_et_al if et_all
    elsif object.respond_to? :et_al_part
      return direct_et_al if et_al_part
    end

    authors = citation_author(first_author)

    unless second_author.nil? || second_author.blank?
      author = citation_author(second_author)
      authors = "#{authors}; #{author}"
    end

    unless third_author.nil? || third_author.blank?
      author = citation_author(third_author)
      authors = "#{authors}; #{author}"
    end

    "(#{authors}, #{year})"
  end

  def indirect_et_al
    "#{citation_author(first_author)} et al. (#{year})"
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
        elements << UnicodeUtils.titlecase(citation_author(author))
      end
    end
    "#{elements.to_sentence} (#{year})"
  end

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def citation_author(author)
    compound_names = []
    names = author.split(' ')
    name = UnicodeUtils.upcase(names.last)
    names.each{ |name|
      ns = CompoundName.where('name like ?', "%#{name}%")
      compound_names += ns unless ns.empty?
    }

    unless compound_names.empty?
      compound_names_included = compound_names.select{ |cn| author.include? cn.name}
      compound_names_included.each{ |n|
        if (n.type_name == 'simple' || n.type_name.nil?) &&
            (n.name == author || author.include?(' ' + n.name))
          name = UnicodeUtils.upcase(n.name)
          break
        elsif n.type_name == 'suffix'
          name = UnicodeUtils.upcase(names[-2] + ' ' + n.name) if names.last == n.name && names.size > 1
        end
      }
    end

    return name
  end


end
