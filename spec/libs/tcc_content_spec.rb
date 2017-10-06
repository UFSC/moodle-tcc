require 'spec_helper'

describe TccContent do
  include TccContent

  new_line               = ["\r\n", "\r\n"]
  emptyParagraph         = ["<p></p>", "<p></p>"]
  emptyParagraphCKEditor = ["<p style=\"text-align: justify;\"></p>", "<p></p>"]
  contentTest            = ["<p style=\"text-align: justify;\">a</p>", "<p>a</p>"]
  contentTestNewLine     = [contentTest[0]+new_line[0], contentTest[1]+new_line[1]]

  contents = [
      ["<p style=\"text-align: justify;\">a</p>",
       "<p>a</p>"],
      ["<p style=\"text-align: justify;\">qwert<img alt=\"\" src=\"/uploads/ckeditor/pictures/499/content_logo.png\" style=\"width: 452px; height: 623px;\" /></p>",
       "<p>qwert<img alt=\"\" src=\"/uploads/ckeditor/pictures/499/content_logo.png\" style=\"width: 452px; height: 623px;\"></p>"],
      ["<p style=\"text-align: justify;\"><strong>qwer</strong></p>",
       "<p><strong>qwer</strong></p>"],
      ["<p style=\"text-align: justify;\">a<strong>qwer</strong></p>",
       "<p>a<strong>qwer</strong></p>"],
      ["<blockquote>\r\n<p style=\"text-align: justify;\">a</p>\r\n</blockquote>",
       "<blockquote>\r\n<p>a</p>\r\n</blockquote>"],
      ["<ol>\r\n\t<li style=\"text-align: justify;\">a</li>\r\n</ol>",
       "<ol>\r\n\t<li>a</li>\r\n</ol>"],
      ["<ul>\r\n\t<li style=\"text-align: justify;\">a</li>\r\n</ul>",
       "<ul>\r\n\t<li>a</li>\r\n</ul>"],
      ["<p style=\"text-align: center;\">a</p>",
       "<p>a</p>"],
      ["<p style=\"text-align: justify; margin-left: 40px;\">a</p>",
       "<p>a</p>"],
      ["<p style=\"text-align: justify;\">a <citacao citacao-text=\"(SINTES, 2001)\" citacao_type=\"cd\" class=\"citacao-class\" contenteditable=\"false\" id=\"2981\" pagina=\"\" ref-type=\"livros\" reference_id=\"10910\" title=\"(SINTES, 2001)\">(SINTES, 2001)</citacao></p>",
       "<p>a <citacao citacao-text=\"(SINTES, 2001)\" citacao_type=\"cd\" class=\"citacao-class\" contenteditable=\"false\" id=\"2981\" pagina=\"\" ref-type=\"livros\" reference_id=\"10910\" title=\"(SINTES, 2001)\">(SINTES, 2001)</citacao></p>"],
      ["<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"width: 500px;\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>teste</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>",
       "<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"width: 500px;\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>qwe</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>\r\n\t\t\t<p>qwe</p>\r\n\t\t\t</td>\r\n\t\t\t<td>teste</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>"],
      ["Inicio do texto<br>\r\nlinha2<br>\r\n<p>linha3</p>\r\n<p>Ultima linha qwert<br></p>",
       "Inicio do texto<br>\r\nlinha2<br>\r\n<p>linha3</p>\r\n<p>Ultima linha qwert<br></p>"],
      ["Inicio do texto<br>\r\n<br>\r\n<p>linha3</p>\r\n<p><br></p>",
       "Inicio do texto<br>\r\n<p>linha3</p>"],
      ["Inicio do texto<br>\r\n<br>\r\n<p>linha3</p>\r\n<p><br></p><br>",
       "Inicio do texto<br>\r\n<p>linha3</p>"],
      ["Inicio do texto<br>\r\n<br>\r\n<p>linha3</p>\r\n<p><br><br></p><br><br>",
       "Inicio do texto<br>\r\n<p>linha3</p>"],
      ["Inicio do texto<br>\r\n<br>\r\n<p>linha3</p>\r\n<p qwer> <br /> <br> </p> <br> <br /> ",
       "Inicio do texto<br>\r\n<p>linha3</p>"],
      ["Inicio do texto\n<p>linha3</p>\r\n<p qwer> <br /> <br> </p> <br> <br /> ",
       "Inicio do texto <p>linha3</p>"],
      ["Inicio do texto\r<p>linha3</p>\r\n<p qwer> <br /> <br> </p> <br> <br /> ",
      "Inicio do texto\r<p>linha3</p>"],
      ["Inicio do texto\n<p>linha3</p>\r\n<p qwer> <br /> <br> </p> <br> <br /> ",
      "Inicio do texto <p>linha3</p>"]
  ]

  shared_examples_for 'remove blank lines with content' do
    before(:each) do
      @content = content[0]
      @expected = content[1]
      puts("Content: #{@content} / Expected: #{@expected}")
      #Rails.logger.info("Content: #{content}")
    end

    it 'only the content' do
      content_converted = TccContent::remove_blank_lines(@content)
      expect(content_converted).to eq(@expected)
    end

    it 'the content and new line' do
      content_converted = TccContent::remove_blank_lines(@content+new_line[0])
      expect(content_converted).to eq(@expected)
    end

    it 'new line and content' do
      content_converted = TccContent::remove_blank_lines(new_line[0]+@content)
      expect(content_converted).to eq(@expected)
    end

    it 'newline, content and new line' do
      content_converted = TccContent::remove_blank_lines(new_line[0]+@content+new_line[0])
      expect(content_converted).to eq(@expected)
    end

    it 'newline, content, new line, content and new line' do
      content_converted = TccContent::remove_blank_lines(new_line[0]+@content+new_line[0]+@content+new_line[0])
      expect(content_converted).to eq(@expected+new_line[0]+@expected)
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
      content_converted = TccContent::remove_blank_lines(@content)
      expect(content_converted).to eq(@content_result)
    end
  end

  shared_examples_for 'test reserved world' do
    before(:each) do
      @reserved_world = reserved_world[0]
      @expected = reserved_world[1]
    end

    describe 'only content' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { contentTestNewLine[0] }
        let(:content_result) { contentTest[1] }
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
        let(:content) { @reserved_world+new_line[0] }
        let(:content_result) { '' }
      end
    end

    describe 'reserved + content' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line[0]+contentTestNewLine[0]}
        let(:content_result) { contentTest[1] }
      end
    end

    describe 'reserved + content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line[0]+contentTestNewLine[0]+@reserved_world+new_line[0] }
        let(:content_result) { contentTest[1] }
      end
    end

    describe 'reserved + content + reserved + content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { @reserved_world+new_line[0]+contentTestNewLine[0]+@reserved_world+new_line[0]+contentTestNewLine[0]+@reserved_world+new_line[0] }
        let(:content_result) { contentTestNewLine[1]+contentTest[1] }
      end
    end

    describe 'content + reserved' do
      it_should_behave_like 'remove blank lines' do
        let(:content) { contentTestNewLine[0]+@reserved_world+new_line[0] }
        let(:content_result) { contentTest[1] }
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
      let(:reserved_world) { emptyParagraph }
    end
  end

  describe 'empty paragraph CKEditor' do
    it_should_behave_like 'test reserved world' do
      let(:reserved_world) { emptyParagraphCKEditor }
    end
  end



end