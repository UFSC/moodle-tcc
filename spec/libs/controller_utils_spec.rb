require 'spec_helper'

describe ControllersUtils do
  new_line = "\r\n\r\n"
  emptyParagraph = "<p></p>"
  emptyParagraphCKEditor = "<p style=\"text-align: justify;\"></p>"
  contentTestNewLine = 'a'+new_line
  contentTest = 'a'


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