require 'timeout'

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

  def TccContent.mount_paragraph(content)
    result_content = '';
    if (content.present?)
      result_content = '<p>'+
                        content+
                        '</p>'
    end
    result_content
  end

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
    space1 = 160.chr("UTF-8")

    newContent.gsub!(/#{space2}/) {" "}
    newContent.gsub!(/#{space1}/) {" "}

    newContent.gsub!(/(<\/p>)/, "</p>\r\n")
    newContent.gsub!(/<p(\s+[^<>]*|)>/, "\r\n<p>")

    nokogiri_html = Nokogiri::HTML.fragment(newContent)

    nokogiri_html.search('p').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<p(\s+[^<>]*|)>/, '<p>')
    end

    # <citacao citacao-text="(SANTOS, 2017)" citacao_type="cd" class="citacao-class" contenteditable="false" id="8999" pagina="undefined" ref-type="internet" reference_id="39643" title="(SANTOS, 2017)"></citacao>
    # <citacao></citacao>
    nokogiri_html.search('p').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<citacao\s?[^>]*>(\s)*<\/citacao>/, '')
    end

    nokogiri_html.search('font').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<font(\s+[^<>]*|)>/, '').gsub('</font>', '')
    end

    nokogiri_html.search('a').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<a(\s+[^<>]*|)>/, '').gsub('</a>', '')
    end

    nokogiri_html.search('li').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<li(\s+[^<>]*|)>/, '<li>')
    end

    nokogiri_html.search('br').each do | paragraph |
      # paragraph.replace  paragraph.to_s.gsub(/<br(\s+[^<>]*|)>/, '<br>')
      paragraph.replace  paragraph.to_s.gsub(/<br(\s+[^<>]*|)>/, "\r\n")

    end

    nokogiri_html.search('div').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<div(\s+[^<>]*|)>/, '').gsub('</div>', '')
    end

    nokogiri_html.search('span').each do | paragraph |
      paragraph.replace  paragraph.to_s.gsub(/<span(\s+[^<>]*|)>/, '').gsub('</span>', '')
    end

    # remove blank lines
    newContent = nokogiri_html.to_html
    lines = newContent.split("\r\n")
    newLines = lines.map { | main_line |
      secondary_lines = main_line.split("\n")
      newSecondaryLines = secondary_lines.map { | sec_line |

        # remove blank lines
        begin
          bol = '^'
          eol = '$'
          # tabs = '\t*'
          spaces = '\s*'
          br = '<br\s*\/?>'
          br_optional = spaces+'('+br+'|)'
          br_optional_multi = '('+br_optional+')*'

          begin_paragraph = '<p\s*[^<]*>'
          end_paragraph = '<\/p\s*>'
          paragraph = begin_paragraph+br_optional_multi+end_paragraph
          paragraph_optional = spaces+'('+paragraph+'|)'
          paragraph_optional_multi = '('+paragraph_optional+')*'

          regexpr = Regexp.new(bol+br_optional_multi+paragraph_optional_multi+br_optional_multi+spaces+eol)

          status = Timeout::timeout(3) {
            if (regexpr.match(sec_line).blank? )
              # se não encontrar uma linha vazia
              sec_line unless sec_line.empty?
            end
          }
        rescue Timeout::Error
          sec_line unless sec_line.empty?
        end
      }.select(&:presence).join("\n")
      newSecondaryLines.chomp!
      main_line = newSecondaryLines
      main_line
    }.select(&:presence).join("\r\n")
    newLines.chomp!

    # !! ordem importa !!
    #
    # (.*)<p\s*[^<]*>(.*)<\/p\s*>
    # 			<p>5</p>
    # => nothing
    #
    # (.*)<p\s*[^<]*>(.*)(<br\s*\/?>)?
    #  	  <p>1<br>
    #  aaa<p>bbb
    # => [1]+<p>+[2]+</p>
    #
    # (.*)<br\s*\/?>
    # 			4<br>
    # => <p>+[1]+</p>
    #
    # (.*)<\/p\s*>
    # 			5</p>
    # => <p>+[1]+</p>
    #
    lines = newLines.split("\r\n")
    newLines = lines.map { | main_line |
      secondary_lines = main_line.split("\n")
      newSecondaryLines = secondary_lines.map { | sec_line |

        # change <br> by <p></p>
        begin
          any_single_character = '(.*)'
          begin_paragraph = '<p\s*[^<]*>'
          end_paragraph = '<\/p\s*>'
          br = '<br\s*\/?>'
          not_tag = '[^<.*>]*'

          # (.*)<p\s*[^<]*>(.*)<\/p\s*>
          # 			<p>5</p>
          # => nothing
          test_complete_paragraph = any_single_character+
              begin_paragraph+
              any_single_character+
              end_paragraph

          # (.*)<p\s*[^<]*>(.*)(<br\s*\/?>)?
          # 			<p>1<br>
          # => [1]+<p>+[2]+</p>
          test_begin_paragraph_end_br = any_single_character+
              begin_paragraph+
              any_single_character+
              "("+br+")?"

          # (.*)<br\s*\/?>
          # 			4<br>
          # => <p>+[1]+</p>
          test_end_br = any_single_character+
              br

          # (.*)<\/p\s*>
          # 			5</p>
          # => <p>+[1]+</p>
          test_end_paragraph = any_single_character+
              end_paragraph

          # test_html_tag = '(.*)<([\/a-z]+)>(.*)'
          test_html_tag = '<(.*)>'

          # test_html_tag_especial = '<(\/?citacao|\/?ins|\/?del)>'
          test_html_tag_especial = '<(\/?citacao|\/?ins|\/?del)>'

          regexpr_complete_paragraph     = Regexp.new(test_complete_paragraph)
          regexpr_begin_paragraph_end_br = Regexp.new(test_begin_paragraph_end_br)
          regexpr_end_br                 = Regexp.new(test_end_br )
          regexpr_end_paragraph          = Regexp.new(test_end_paragraph)
          regexpr_html_tag               = Regexp.new(test_html_tag)
          regexpr_html_tag_especial      = Regexp.new(test_html_tag_especial)

          status = Timeout::timeout(3) {
            if (regexpr_complete_paragraph.match(sec_line).present? )
              # (.*)<p\s*[^<]*>(.*)<\/p\s*>
              # 			<p>5</p>
              # => nothing
              sec_line
            elsif (regexpr_begin_paragraph_end_br.match(sec_line).present? )
              # (.*)<p\s*[^<]*>(.*)<br\s*\/?>
              # 			<p>1<br>
              # => [1]+<p>+[2]+</p>
              sec_line = regexpr_begin_paragraph_end_br.match(sec_line)[1]+
                  TccContent::mount_paragraph(regexpr_begin_paragraph_end_br.match(sec_line)[2])
              # sec_line = regexpr_begin_paragraph_end_br.match(sec_line)[1]+
              #     '<p>'+
              #     regexpr_begin_paragraph_end_br.match(sec_line)[2]+
              #     '</p>'
              sec_line
            elsif (regexpr_end_br.match(sec_line).present?)

              # (.*)<br\s*\/?>
              # 			4<br>
              # => <p>+[1]+</p>
              sec_line = TccContent::mount_paragraph(regexpr_end_br.match(sec_line)[1])
              # sec_line = '<p>'+
              #     regexpr_end_br.match(sec_line)[1]+
              #     '</p>'
              sec_line
            elsif (regexpr_end_paragraph.match(sec_line).present?)

              # (.*)<\/p\s*>
              # 			5</p>
              # => <p>+[1]+</p>
              sec_line = TccContent::mount_paragraph(regexpr_end_paragraph.match(sec_line)[1]);
              # sec_line = '<p>'+
              #     regexpr_end_paragraph.match(sec_line)[1]+
              #     '</p>'
              sec_line
            elsif (regexpr_html_tag.match(sec_line).blank?)

              # <(.*)>
              # \t\ttexto
              # => <p>\t\ttexto</p>
              sec_line = TccContent::mount_paragraph(sec_line)
              # sec_line = '<p>'+
              #     sec_line+
              #     '</p>'
              sec_line
            elsif (regexpr_html_tag_especial.match(sec_line).present?)

              # <(\/?citacao|\/?ins|\/?del)>
              # \t\ttexto<citacao ...>...</citacao>
              # => <p>\t\ttexto<citacao ...>...</citacao></p>
              sec_line = TccContent::mount_paragraph(sec_line)
              # sec_line = '<p>'+
              #     sec_line+
              #     '</p>'
              sec_line
            else
              sec_line
            end
          }
        rescue Timeout::Error
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

    #troca <br /> por \r\n
    content_typed = content_typed.gsub(/<br(\s+[^<>]*|)>/, "\r\n")

    new_content = TccContent::remove_blank_lines( content_typed )

    if ((content_server.blank?) || !content_server.eql?(new_content))
      # Se não houver conteúdo do servidor (import do Moodle)
      # ou
      # Conteúdo do servidor diferente

      # então conta palavras para verificar se não perdeu texto na limpeza de linhas em branco
      if content_typed.present?
        array_typed = Rails::Html::FullSanitizer.new.sanitize(content_typed).
          split("\r\n").join(' ').split(' ').select(&:presence)
        count_typed = array_typed.count
      end
      if array_typed.present? &&
          array_typed.last.present? &&
          array_typed.last.eql?(Rails.application.secrets.error_key)
        # chave para gerar o erro
        # força gerar o erro para o servidor
        count_new = -1
      else
        if new_content.present?
          count_new = Rails::Html::FullSanitizer.new.sanitize(new_content).
              split("\r\n").join(' ').split(' ').select(&:presence).count
        end
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
