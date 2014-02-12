require 'spec_helper'

describe ThesisRef do
  context 'validations' do
    before(:all) { @thesis_ref = Fabricate(:thesis_ref) }
    after(:all) { @thesis_ref.destroy }

    it { should respond_to(:author, :chapter, :course, :degree, :department, :institution, :local,
                           :pages_or_volumes_number, :subtitle, :title, :type_thesis, :type_number, :year) }
    it { should have_one(:reference) }

    it { should have_one(:tcc).through(:reference) }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_numericality_of(:year).only_integer }
    it { should validate_presence_of(:institution) }
    it { should validate_presence_of(:pages_or_volumes_number) }
    it { should validate_presence_of(:type_number) }
    it { should ensure_inclusion_of(:type_number).in_array(ThesisRef::TYPES) }
    it { should ensure_inclusion_of(:type_thesis).in_array(ThesisRef::THESIS_TYPES) }
    it { should ensure_inclusion_of(:degree).in_array(ThesisRef::DEGREE_TYPES) }

    it { should validate_presence_of(:course) }


  end

  context 'authors' do
    let(:thesis_ref) { Fabricate.build(:thesis_ref) }
    describe 'author' do
      it 'should have last name' do
        thesis_ref.author = 'firstname'
        thesis_ref.should_not be_valid
        thesis_ref.author = 'firstname lastname'
        thesis_ref.should be_valid
      end
    end
  end


  context 'citacoes' do
    let(:thesis_ref) { Fabricate.build(:thesis_ref) }

    describe '#direct_citation' do

      it 'should include author' do
        last_name = UnicodeUtils.upcase(thesis_ref.author.split(' ').last)
        thesis_ref.direct_citation.should include("#{last_name}")
      end

      it 'should include year' do
        thesis_ref.direct_citation.should include(thesis_ref.year.to_s)
      end

      it 'should include (' do
        thesis_ref.direct_citation.should include('(')
      end

      it 'should include )' do
        thesis_ref.direct_citation.should include(')')
      end

    end

  end


  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        BookCapRef.destroy_all
      end

      it 'should invoke callback' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.should_receive(:check_equality)
        thesis_ref1.save!
      end

      it 'subtype should be nil' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.author = 'Autor A1'

        thesis_ref1.save!

        thesis_ref1.subtype.should be_nil
      end

      it 'subtype should be nil after one update' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.author = 'Autor A1'

        thesis_ref1.save!
        thesis_ref1.save!

        thesis_ref1.subtype.should be_nil
      end

      it 'subtype should be set correctly' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.author = 'Autor A1'

        thesis_ref1.save!

        thesis_ref2 = Fabricate.build(:thesis_ref)
        thesis_ref2.author = 'Autor A1'

        thesis_ref2.save!

        thesis_ref1.reload

        thesis_ref1.subtype.should == 'a'
        thesis_ref2.subtype.should == 'b'

      end

      it 'should set subtype to nil if object is different' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.author = 'Autor A1'

        thesis_ref1.save!

        thesis_ref2 = Fabricate.build(:thesis_ref)
        thesis_ref2.author = 'Autor A1'

        thesis_ref2.save!

        thesis_ref1.reload

        thesis_ref1.subtype.should == 'a'
        thesis_ref2.subtype.should == 'b'

        thesis_ref2
        thesis_ref2.author = 'Autor A10'
        thesis_ref2.save!
        thesis_ref1.reload
        thesis_ref2.reload

        thesis_ref1.subtype.should be_nil
        thesis_ref2.subtype.should be_nil

      end

    end
  end

  context '#indirect_citation' do
    it_should_behave_like "indirect_citation" do
      let(:ref) { Fabricate(:thesis_ref) }
    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:ref) { Fabricate.build(:thesis_ref) }
  end
end
