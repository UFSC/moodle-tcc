class GenericReferenceDecorator < Draper::Decorator
  delegate_all

  def direct_et_al
    "(#{citation_author(first_author)} et al., #{year})"
  end

  def direct_citation
    # Pequena diferença de nomes nos models, talvez seja boa ideia considerar a troca para igualar
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

  def bibtex_translate(text)

    if text.present?
    # begin
      text = text.gsub(/[á]/, "{\\ 'a}")
      text = text.gsub(/[é]/, "{\\ 'e}")
      text = text.gsub(/[í]/, "{\\ 'i}")
      text = text.gsub(/[ó]/, "{\\ 'o}")
      text = text.gsub(/[ú]/, "{\\ 'u}")

      text = text.gsub(/[à]/, "{\\ `a}")
      text = text.gsub(/[è]/, "{\\ `e}")
      text = text.gsub(/[ì]/, "{\\ `i}")
      text = text.gsub(/[ò]/, "{\\ `o}")
      text = text.gsub(/[ù]/, "{\\ `u}")

      text = text.gsub(/[ã]/, "{\\ ~a}")
      text = text.gsub(/[ẽ]/, "{\\ ~e}")
      text = text.gsub(/[ĩ]/, "{\\ ~i}")
      text = text.gsub(/[õ]/, "{\\ ~o}")
      text = text.gsub(/[ũ]/, "{\\ ~u}")

      text = text.gsub(/[â]/, "{\\ ^a}")
      text = text.gsub(/[ê]/, "{\\ ^e}")
      text = text.gsub(/[î]/, "{\\ ^i}")
      text = text.gsub(/[ô]/, "{\\ ^o}")
      text = text.gsub(/[û]/, "{\\ ^u}")

      text = text.gsub(/[ä]/, "{\\\"a}")
      text = text.gsub(/[ë]/, "{\\\"e}")
      text = text.gsub(/[ï]/, "{\\\"i}")
      text = text.gsub(/[ö]/, "{\\\"o}")
      text = text.gsub(/[ü]/, "{\\\"u}")

      text = text.gsub(/[ç]/, "{\\ c c}")
      text = text.gsub(" c c", "c c")

      text = text.gsub(" '", "'")
      text = text.gsub(" ^", "^")
      text = text.gsub(" ~", "~")
      text = text.gsub(" `", "`")

      # %$€©µΩ℃™®

      # %$
      text = text.gsub("%", "{\\textpercent}")
      text = text.gsub("$", "{\\textdollar}")

      # €©µΩ℃™®
      text = text.gsub("€", "{\\texteuro}")
      text = text.gsub("©", "{\\textcopyright}")
      text = text.gsub("µ", "{\\textmu}")
      text = text.gsub("Ω", "{\\textohm}")
      # α
      # text = text.gsub("α", "{\\textalpha}")
      text = text.gsub("℃", "{\\textcelsius}")
      text = text.gsub("™", "{\\texttrademark}")
      text = text.gsub("®", "{\\textregistered}")
    end

    text
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

  # puts(reference.element.decorate.mount_citation_tag(reference, 'cd'))
  # @param [Reference] reference Referência da citação
  # @param [String] ctype ['cd','ci'] respectivamente citacao direta e indireta
  # @param [Integer] pagina citada
  # @return [String] Tag html contedo as informações da citação
  def mount_citation_tag(reference, ctype, pagina = 'undefined')
    def get_reference_type (ref_type)
      Conversor::REFERENCES_TYPE.each {| x, y|
        return x if ref_type.eql?(y)
      }
      false
    end
    text = reference.element.decorate.send( Conversor::CITACAO_TYPE[ctype])
    citation = 'citacao-text='.concat(%Q["#{text}"])
    citation += ' citacao_type='.concat(%Q["#{ctype}"])
    citation += ' class='.concat(%Q["citacao-class"])
    citation += ' contenteditable='.concat(%Q["false"])
    citation += ' id='.concat(%Q["#{reference.element_id}"])
    citation += ' pagina='.concat(%Q["#{ pagina }"])
    citation += ' ref-type='.concat(%Q["#{get_reference_type(reference.element_type)}"])
    citation += ' reference_id='.concat(%Q["#{reference.id}"])
    citation += ' title='.concat(%Q["#{text}"])
    "<citacao #{citation}>#{text}</citacao>"
  end

end
