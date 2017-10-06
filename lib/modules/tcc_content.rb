module TccContent

  class CleaningBlankLinesError < RuntimeError;
    def initialize
      @http_code = 500
    end

    # The library expects you to define this method. You must return a Hash,
    # containing the keys you want to modify.
    def to_airbrake
      { params:
                 { http_code: @http_code,
                   test: '123'
                   # user: ,
                   # session:
                 },
        session: {
            content: '321'
        }
      }
    end
    # The `{ http_code: 404 }` Hash will transported to the Airbrake dashboard via
    # the `#to_airbrake` method.
    #
    # Airbrake.notify(CleaningBlankLinesError.new)
  end

  # def initialize
  #   super
  # end

  def TccContent.remove_blank_lines(content)
    ## O CKEditor está realizando a limpeza de linhas em branco
    # config.autoParagraph = false; # no config.js do editor

    return nil if content.nil?
    newContent = content
    ## tira linhas em branco

    # LF: Line Feed, U+000A (UTF-8 in hex: 0A)
    # CR: Carriage Return, U+000D (UTF-8 in hex: 0D)
    # CR+LF: CR (U+000D) followed by LF (U+000A) (UTF-8 in hex: 0D0A)

    # U+00A0	/	194 160	/ NO-BREAK SPACE
    space2 = 194.chr("UTF-8")+160.chr("UTF-8")
    newContent.gsub!(/#{space2}/) {" "}
    space1 = 160.chr("UTF-8")
    newContent.gsub!(/#{space1}/) {" "}

    nokogiri_html = Nokogiri::HTML.fragment(newContent)

    nokogiri_html.search('p').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<p(\s+[^<>]*|)>/, '<p>')
    end

    nokogiri_html.search('font').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<font(\s+[^<>]*|)>/, '').gsub('</font>', '')
    end

    nokogiri_html.search('li').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<li(\s+[^<>]*|)>/, '<li>')
    end

    nokogiri_html.search('div').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<div(\s+[^<>]*|)>/, '').gsub('</div>', '')
    end

    nokogiri_html.search('span').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<span(\s+[^<>]*|)>/, '').gsub('</span>', '')
    end

    newContent = nokogiri_html.to_html
    lines = newContent.split("\r\n")
    newLines = lines.map { | main_line |
      secondary_lines = main_line.split("\n")
      newSecondaryLines = secondary_lines.map { | sec_line |
        if (/^(\t)*(<p(\s[^<]*|)>(\s*(<br(\s*\/?|)>|))*(\s)*<\/p\s*>|)(\s*(<br(\s*\/?|)>|))*(\s)*$/.match(sec_line).blank? )
          # se não encontrar uma linha apenas com <br>
          sec_line unless sec_line.empty?
        end
      }.select(&:presence).join(" ")
      newSecondaryLines.chomp!
      main_line = newSecondaryLines
      main_line
    }.select(&:presence).join("\r\n")
    newLines.chomp!

    newContent = newLines
    newContent
  end

  def TccContent.changedContent?(content_server, content_typed)

    new_content = TccContent::remove_blank_lines( content_typed)

    content_server.eql?(new_content)

  end

  def TccContent.removeBlankLinesFromContent(content_server, content_typed)
    count_typed = 0
    count_new = 0

    new_content = TccContent::remove_blank_lines( content_typed )

    if !content_server.eql?(new_content)
      array_typed = Rails::Html::FullSanitizer.new.sanitize(content_typed).
          split("\r\n").join(' ').split(' ').select(&:presence)
      count_typed = array_typed.count
      if array_typed.present? &&
          array_typed.last.present? &&
          array_typed.last.eql?(Rails.application.secrets.error_key)
        # chave para gerar o erro
        # força gerar o erro para o servidor
        count_new = -1
      else
        count_new = Rails::Html::FullSanitizer.new.sanitize(new_content).
            split("\r\n").join(' ').split(' ').select(&:presence).count
      end
    end

    if !(count_typed.eql?(count_new))
      # se o texto digitado for diferente do texto com as linhas em branco removidas,
      #   então gera o erro
      msg_error = I18n.t('error_tcc_content_cleaning_blank_lines')
      raise TccContent::CleaningBlankLinesError.new, msg_error
    end

    new_content
  end

end
