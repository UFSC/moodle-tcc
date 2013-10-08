require 'spec_helper'

describe Conversor do

  describe 'conversor' do
    let(:tcc) { Fabricate.build(:tcc) }

    describe 'article_refs' do

    end
    describe 'book_cap_refs' do

    end
    describe 'book_refs' do

    end
    describe 'general_refs' do

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

        citacao = citacao(title, citacao_type, class_type, ref_id, "[[#{Conversor::REFERENCES_TYPE.invert[ref.class.to_s]}#{ref.id} #{ref.title}]]")
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.direct_citation)

      end
      it 'should convert citacao indireta' do
        ref = Fabricate(:internet_ref)
        tcc.save!
        tcc.references.create!(element: ref)

        title = ref.title
        citacao_type = "ci"
        class_type = Conversor::REFERENCES_TYPE.invert[ref.class.to_s]
        ref_id = ref.id


        citacao = citacao(title, citacao_type, class_type, ref_id, "[[#{Conversor::REFERENCES_TYPE.invert[ref.class.to_s]}#{ref.id} #{ref.title}]]")
        text = Conversor::convert_text(citacao, tcc)

        text.rstrip.should == citacao(title, citacao_type, class_type, ref_id, ref.indirect_citation)
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
        citacao = citacao(title, citacao_type, class_type, ref_id, "[[#{Conversor::REFERENCES_TYPE.invert[ref.class.to_s]}#{ref.id} #{ref.title}]]")
        text = prefix+citacao+sufix

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.direct_citation)+sufix

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

        citacao = citacao(title, citacao_type, class_type, ref_id, "[[#{Conversor::REFERENCES_TYPE.invert[ref.class.to_s]}#{ref.id} #{ref.title}]]")

        title1 = ref1.title
        citacao_type1 = "cd"
        class_type1 = Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]
        ref_id1 = ref1.id

        citacao1 = citacao(title1, citacao_type1, class_type1, ref_id1, "[[#{Conversor::REFERENCES_TYPE.invert[ref1.class.to_s]}#{ref1.id} #{ref1.title}]]")

        prefix = Faker::Lorem.paragraph(1)
        sufix = Faker::Lorem.paragraph(1)

        text = prefix+citacao+sufix+citacao1

        text = Conversor::convert_text(text, tcc)
        text.rstrip.should == prefix+citacao(title, citacao_type, class_type, ref_id, ref.direct_citation)+sufix+citacao(title1, citacao_type1, class_type1, ref_id1, ref1.direct_citation)

      end
    end
    describe 'legislative_refs' do

    end


    def citacao(title, citacao_type, class_type, id, text)
      %Q(<citacao citacao-text="#{title}" citacao_type="#{citacao_type}" class="citacao-class" contenteditable="false" id="#{id}" ref-type="#{class_type}" title="#{text}">#{text}</citacao>)
    end

  end

end