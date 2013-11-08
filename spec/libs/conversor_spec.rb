require 'spec_helper'

describe Conversor do

  let(:tcc) { Fabricate.build(:tcc) }
  let(:prefix) { Faker::Lorem.paragraph(1) }
  let(:sufix) { Faker::Lorem.paragraph(1) }
  CITACAO_TYPES = {:direta => 'cd', :indireta => 'ci'}

  shared_examples_for "citation" do
    before(:each) do
      tcc.save!
      tcc.references.create!(element: ref)
      tcc.references.create!(element: ref1)
    end

    it 'should not modify a text without citation' do
      old_text = '<p>algumacoisa</p>/n<p>alguma outra coisa</p>'
      converted_text = Conversor::convert_text(old_text, tcc)

      expect(converted_text).to eq(old_text)
    end

    context 'when converting direct citation' do
      it 'should be idepotent and have the same results with new citations' do
      end

      it 'should convert and old citation to the new format' do
        old_citacao = build_tag_citacao(ref, :direta, old_citacao_text(ref, ref.title))
        new_citacao = build_tag_citacao(ref, :direta, ref.direct_citation)

        converted_text = Conversor::convert_text(old_citacao, tcc)
        converted_text.should == new_citacao
      end

      it 'should convert citation with any text before and after' do
        old_citacao = build_tag_citacao(ref, :direta, old_citacao_text(ref, ref.title))

        old_text = prefix+old_citacao+sufix
        old_text = Conversor::convert_text(old_text, tcc)

        new_text = "<p>"+prefix+build_tag_citacao(ref, :direta, ref.direct_citation)+sufix+"</p>"

        old_text.should == new_text
      end

      it 'should convert all citations from text' do
        old_citacao = build_tag_citacao(ref, :direta, old_citacao_text(ref, ref.title))
        another_old_citacao = build_tag_citacao(ref1, :direta, old_citacao_text(ref1, ref1.title))

        old_text = prefix+old_citacao+sufix+another_old_citacao
        old_text = Conversor::convert_text(old_text, tcc)

        new_citation1 = build_tag_citacao(ref, :direta, ref.direct_citation)
        new_citation2 = build_tag_citacao(ref1, :direta, ref1.direct_citation)

        new_text = "<p>#{prefix}#{new_citation1}#{sufix}#{new_citation2}</p>"

        old_text.should == new_text
      end
    end

    context 'when converting indirect citation' do
      it 'should be idepotent and have the same results with new citations' do
      end

      it 'should convert and old citation to the new format' do
        old_citacao = build_tag_citacao(ref, :indireta, old_citacao_text(ref, ref.title))
        new_citacao = build_tag_citacao(ref, :indireta, ref.indirect_citation)

        old_text = Conversor::convert_text(old_citacao, tcc)
        old_text.should == new_citacao
      end

      it 'should convert citation with any text before and after' do
        old_citacao = build_tag_citacao(ref, :indireta, old_citacao_text(ref, ref.title))

        old_text = prefix+old_citacao+sufix
        old_text = Conversor::convert_text(old_text, tcc)

        new_citacao = build_tag_citacao(ref, :indireta, ref.indirect_citation)
        new_text = "<p>#{prefix}#{new_citacao}#{sufix}</p>"

        old_text.should == new_text
      end

      it 'should convert all citations from text' do
        old_citacao = build_tag_citacao(ref, :indireta, old_citacao_text(ref, ref.title))
        another_old_citacao = build_tag_citacao(ref1, :indireta, old_citacao_text(ref1, ref1.title))

        old_text = prefix+old_citacao+sufix+another_old_citacao
        old_text = Conversor::convert_text(old_text, tcc)

        new_citation1 = build_tag_citacao(ref, :indireta, ref.indirect_citation)
        new_citation2 = build_tag_citacao(ref1, :indireta, ref1.indirect_citation)

        new_text = "<p>#{prefix}#{new_citation1}#{sufix}#{new_citation2}</p>"

        old_text.should == new_text
      end
    end
  end

  describe 'article_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:article_ref) }
      let(:ref1) { Fabricate(:article_ref) }
    end
  end

  describe 'book_cap_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:book_cap_ref) }
      let(:ref1) { Fabricate(:book_cap_ref) }
    end
  end

  describe 'book_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:book_ref) }
      let(:ref1) { Fabricate(:book_ref) }
    end
  end

  describe 'general_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:general_ref) }
      let(:ref1) { Fabricate(:general_ref) }
    end
  end

  describe 'internet_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:internet_ref) }
      let(:ref1) { Fabricate(:internet_ref) }
    end
  end

  describe 'legislative_refs' do
    it_should_behave_like "citation" do
      let(:ref) { Fabricate(:legislative_ref) }
      let(:ref1) { Fabricate(:legislative_ref) }
    end
  end

  def build_tag_citacao(model, citacao_type, text)
    %Q(<citacao citacao-text="#{model.title}" citacao_type="#{CITACAO_TYPES[citacao_type]}" class="citacao-class" contenteditable="false" id="#{model.id}" ref-type="#{Conversor::REFERENCES_TYPE.invert[model.class.to_s]}" title="#{text}" reference_id="#{model.reference.id}">#{text}</citacao>)
  end

  def old_citacao_text(model, title)
    "[[#{Conversor::REFERENCES_TYPE.invert[model.class.to_s]}#{model.id} #{title}]]"
  end

end