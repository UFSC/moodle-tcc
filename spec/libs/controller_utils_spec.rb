require 'spec_helper'

describe ControllersUtils do
  new_line = "\r\n\r\n"
  emptyParagraph = "<p></p>"
  emptyParagraphCKEditor = "<p style=\"text-align: justify;\"></p>"
  contentTest = "<p style=\"text-align: justify;\">a</p>"
  contentTestNewLine = contentTest+new_line

  contents = [ "<p style=\"text-align: justify;\">a</p>",
               "<p style=\"text-align: justify;\">qwert<img alt=\"\" src=\"/uploads/ckeditor/pictures/499/content_logo.png\" style=\"width: 452px; height: 623px;\" /></p>",
               "<p style=\"text-align: justify;\"><strong>qwer</strong></p>",
               "<p style=\"text-align: justify;\">a<strong>qwer</strong></p>",
               "<blockquote>\r\n<p style=\"text-align: justify;\">a</p>\r\n</blockquote>",
               "<ol>\r\n\t<li style=\"text-align: justify;\">a</li>\r\n</ol>",
               "<ul>\r\n\t<li style=\"text-align: justify;\">a</li>\r\n</ul>",
               "<p style=\"text-align: center;\">a</p>",
               "<p style=\"text-align: justify; margin-left: 40px;\">a</p>",
               "<p style=\"text-align: justify;\">a <citacao citacao-text=\"(SINTES, 2001)\" citacao_type=\"cd\" class=\"citacao-class\" contenteditable=\"false\" id=\"2981\" pagina=\"\" ref-type=\"livros\" reference_id=\"10910\" title=\"(SINTES, 2001)\">(SINTES, 2001)</citacao></p>",
               "<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"width: 500px;\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>teste</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>"
  ]

  shared_examples_for 'remove blank lines with content' do
    before(:each) do
      @content = content
      puts("Content: #{content}")
      #Rails.logger.info("Content: #{content}")
    end

    it 'only the content' do
      content_converted = ControllersUtils::remove_blank_lines(@content)
      expect(content_converted).to eq(@content)
    end

    it 'the content and new line' do
      content_converted = ControllersUtils::remove_blank_lines(@content+new_line)
      expect(content_converted).to eq(@content)
    end

    it 'new line and content' do
      content_converted = ControllersUtils::remove_blank_lines(new_line+@content)
      expect(content_converted).to eq(@content)
    end

    it 'newline, content and new line' do
      content_converted = ControllersUtils::remove_blank_lines(new_line+@content+new_line)
      expect(content_converted).to eq(@content)
    end

    it 'newline, content, new line, content and new line' do
      content_converted = ControllersUtils::remove_blank_lines(new_line+@content+new_line+@content+new_line)
      expect(content_converted).to eq(@content+new_line+@content)
    end

  end

  describe 'all content' do
    contents.each do | content |
      it_should_behave_like 'remove blank lines with content' do
        let(:content) { content }
      end
    end
  end

  shared_examples_for 'remove blank lines' do
    before(:each) do
      @content = content
      @content_result = content_result
    end
    it 'from one line content' do
      content_converted = ControllersUtils::remove_blank_lines(@content)
      expect(content_converted).to eq(@content_result)
    end
  end

  shared_examples_for 'test reserved world' do
    before(:each) do
      @reserved_world = reserved_world
    end

    describe 'only content' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { contentTestNewLine }
        let(:content_result) { contentTest }
      end
    end

    describe 'only reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world }
        let(:content_result) { '' }
      end
    end

    describe 'reserved + new_line' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line }
        let(:content_result) { '' }
      end
    end

    describe 'reserved + content' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line+contentTestNewLine}
        let(:content_result) { contentTest }
      end
    end

    describe 'reserved + content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line+contentTestNewLine+@reserved_world+new_line }
        let(:content_result) { contentTest }
      end
    end

    describe 'reserved + content + reserved + content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line+contentTestNewLine+@reserved_world+new_line+contentTestNewLine+@reserved_world+new_line }
        let(:content_result) { contentTestNewLine+contentTest }
      end
    end

    describe 'content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { contentTestNewLine+@reserved_world+new_line }
        let(:content_result) { contentTest }
      end
    end

  end

  describe 'new_line' do
    it_should_behave_like 'test reserved world' do
      let(:reserved_world) { new_line }
    end
  end

  describe 'empty paragraph' do
    it_should_behave_like 'test reserved world' do
      let(:reserved_world) { emptyParagraph+new_line }
    end
  end

  describe 'empty paragraph CKEditor' do
    it_should_behave_like 'test reserved world' do
      let(:reserved_world) { emptyParagraphCKEditor+new_line }
    end
  end



end