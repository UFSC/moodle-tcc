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
    newLines = lines.map { | x |
      if (/^(\t)*(<p(\s[^<]*|)>(\s*(<br(\s*\/?|)>|))*(\s)*<\/p\s*>|)(\s*(<br(\s*\/?|)>|))*(\s)*$/.match(x).blank? )
        # se não encontrar uma linha apenas com <br>
        x unless x.empty?
      end
    }.compact.join("\r\n")
    newLines.chomp!

    newContent = newLines
    newContent
  end



end
