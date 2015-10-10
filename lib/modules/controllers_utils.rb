module ControllersUtils

  def self.remove_blank_lines(content)
    ## O CKEditor está realizando a limpeza de linhas em branco
    # config.autoParagraph = false; # no config.sj do editor

    return nil if content.nil?
    newContent = content
    ## tira linhas em branco
    # U+00A0	/	194 160	/ NO-BREAK SPACE
    space2 = 194.chr("UTF-8")+160.chr("UTF-8")
    newContent.gsub!(/#{space2}/) {" "}
    space1 = 160.chr("UTF-8")
    newContent.gsub!(/#{space1}/) {" "}

    lines = newContent.split("\r\n\r\n")
    newLines = lines.map { | x |
      # se não encontrar parágrafo com "tag" e texto com espaços
      if /^<p(.*)>(.*)<(.*)\/(.*)>(\s*)<\/p>$/.match(x).blank?
        # se não encontrar parágrafo e texto com espaços
        if (/^<p(.*)>(\s*)<\/p>$/.match(x).blank? )
          # então adiciona o texto em newLines
          x unless x.empty?
          # senão, se encontrar parágrafo e texto com espaços
          # então abandona o texto e não adiciona em newLines
        end
      else
        # se encontrar parágrafo com "imagem" e texto com espaços
        # então adiciona o texto em newLines
        x unless x. empty?
      end
    }.compact.join("\r\n\r\n")
    newLines.chomp!
    newContent = newLines
    newContent
  end

end