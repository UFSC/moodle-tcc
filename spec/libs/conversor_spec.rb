require 'spec_helper'

describe Conversor do

  describe 'conversor' do
    let(:tcc) { Fabricate.build(:tcc) }
    let(:prefix) { Faker::Lorem.paragraph(1) }
    let(:sufix) { Faker::Lorem.paragraph(1) }
    CITACAO_TYPES = {:direta => 'cd', :indireta => 'ci'}

    describe 'article_refs' do
      let(:ref) { Fabricate(:article_ref) }
      let(:ref1) { Fabricate(:article_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.article_title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.article_title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end
      it 'should convert all citacao from text' do
        citacao = citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        citacao1 = citacao(ref1.article_title, CITACAO_TYPES[:direta], @class_type1, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.article_title))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.article_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.article_title, CITACAO_TYPES[:direta], @class_type1, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    describe 'book_cap_refs' do
      let(:ref) { Fabricate(:book_cap_ref) }
      let(:ref1) { Fabricate(:book_cap_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.book_title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.book_title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end

      it 'should convert all citacao from text' do
        citacao = citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        citacao1 = citacao(ref1.book_title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.book_title))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.book_title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.book_title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    describe 'book_refs' do
      let(:ref) { Fabricate(:book_ref) }
      let(:ref1) { Fabricate(:book_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end

      it 'should convert all citacao from text' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        citacao1 = citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    describe 'general_refs' do
      let(:ref) { Fabricate(:general_ref) }
      let(:ref1) { Fabricate(:general_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.reference_text, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.reference_text, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end

      it 'should convert all citacao from text' do
        citacao = citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        citacao1 = citacao(ref1.reference_text, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.reference_text))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.reference_text, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.reference_text, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    describe 'internet_ref' do
      let(:ref) { Fabricate(:internet_ref) }
      let(:ref1) { Fabricate(:internet_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end

      it 'should convert all citacao from text' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        citacao1 = citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    describe 'legislative_refs' do
      let(:ref) { Fabricate(:legislative_ref) }
      let(:ref1) { Fabricate(:legislative_ref) }

      before(:each) do
        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)
        @class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
      end

      it 'should convert citacao direta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)
      end
      it 'should convert citacao indireta' do
        citacao = citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)
        text.rstrip.should == citacao(ref.title, CITACAO_TYPES[:indireta], @class_type, ref.id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix
      end

      it 'should convert all citacao from text' do
        citacao = citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        citacao1 = citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))
        text = prefix+citacao+sufix+citacao1
        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(ref.title, CITACAO_TYPES[:direta], @class_type, ref.id, ref.reference.id, ref.direct_citation)+sufix+citacao(ref1.title, CITACAO_TYPES[:direta], @class_type, ref1.id, ref1.reference.id, ref1.direct_citation)
      end
    end

    def citacao(title, citacao_type, class_type, id, reference_id, text)
      %Q(<citacao citacao-text="#{title}" citacao_type="#{citacao_type}" class="citacao-class" contenteditable="false" id="#{id}" ref-type="#{class_type}" title="#{text}" reference_id="#{reference_id}">#{text}</citacao>)
    end

    def old_citacao_text(c, id, title)
      "[[#{Conversor::REFERENCES_TYPE.invert[c]}#{id} #{title}]]"
    end

  end

end