require 'spec_helper'

describe Conversor do

  describe 'conversor' do
    let(:tcc) { Fabricate.build(:tcc) }

    describe 'article_refs' do
      it 'should convert citacao direta' do
        ref = Fabricate(:article_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.article_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:article_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.article_title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:article_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.article_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:article_ref)
        ref1 = Fabricate(:article_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.article_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.article_title))

        title1 = ref1.article_title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id,  old_citacao_text(ref1.class.to_s, ref1.id, ref1.article_title))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

      end
    end
    describe 'book_cap_refs' do
      it 'should convert citacao direta' do
        ref = Fabricate(:book_cap_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.book_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:book_cap_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.book_title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:book_cap_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.book_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:book_cap_ref)
        ref1 = Fabricate(:book_cap_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.book_title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.book_title))

        title1 = ref1.book_title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.book_title))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id,  ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

      end
    end
    describe 'book_refs' do
      it 'should convert citacao direta' do
        ref = Fabricate(:book_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:book_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:book_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:book_ref)
        ref1 = Fabricate(:book_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))

        title1 = ref1.title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id,  old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

      end
    end
    describe 'general_refs' do
      it 'should convert citacao direta' do
        ref = Fabricate(:general_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.reference_text
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:general_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.reference_text
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:general_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.reference_text
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:general_ref)
        ref1 = Fabricate(:general_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.reference_text
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.reference_text))

        title1 = ref1.reference_text
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.reference_text))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

      end
    end
    describe 'internet_ref' do
      it 'should convert citacao direta' do
        ref = Fabricate(:internet_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:internet_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:internet_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:internet_ref)
        ref1 = Fabricate(:internet_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))

        title1 = ref1.title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

      end
    end
    describe 'legislative_refs' do
      it 'should convert citacao direta' do
        ref = Fabricate(:legislative_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:legislative_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.indirect_citation)
      end
      it 'should just convert citacao' do
        ref = Fabricate(:legislative_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)
        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix

      end

      it 'should convert all citacao from text' do
        ref = Fabricate(:legislative_ref)
        ref1 = Fabricate(:legislative_ref)

        tcc.save!
        tcc.references.create!(element: ref)
        tcc.references.create!(element: ref1)

        title = ref.title
        citacao_type = "cd"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id

        citacao = citacao(title, citacao_type, class_type, ref_id, ref.reference.id, old_citacao_text(ref.class.to_s, ref.id, ref.title))

        title1 = ref1.title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, old_citacao_text(ref1.class.to_s, ref1.id, ref1.title))

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.reference.id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.reference.id, ref1.direct_citation)

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