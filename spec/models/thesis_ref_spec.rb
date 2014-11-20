require 'spec_helper'

describe ThesisRef do
  context 'validations' do
    before(:all) { @thesis_ref = Fabricate(:thesis_ref) }
    after(:all) { @thesis_ref.destroy }

    it { should respond_to(:first_author, :second_author, :third_author, :et_all, :chapter, :course, :degree,
                           :department, :institution, :local, :pages_or_volumes_number,
                           :subtitle, :title, :type_thesis, :type_number, :year) }
    it { should have_one(:reference) }

    it { should have_one(:tcc).through(:reference) }

    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_numericality_of(:year).only_integer }
    it { should validate_presence_of(:institution) }
    it { should validate_presence_of(:pages_or_volumes_number) }
    it { should validate_presence_of(:type_number) }
    it { should validate_inclusion_of(:type_number).in_array(ThesisRef::TYPES) }
    it { should validate_inclusion_of(:type_thesis).in_array(ThesisRef::THESIS_TYPES) }
    it { should validate_inclusion_of(:degree).in_array(ThesisRef::DEGREE_TYPES) }

    it { should validate_presence_of(:course) }

  end

  context 'normalizations' do
    it { should normalize_attribute(:first_author) }
    it { should normalize_attribute(:first_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:second_author) }
    it { should normalize_attribute(:second_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:third_author) }
    it { should normalize_attribute(:third_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:title) }
    it { should normalize_attribute(:title).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:subtitle) }
    it { should normalize_attribute(:subtitle).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:local) }
    it { should normalize_attribute(:local).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:institution) }
    it { should normalize_attribute(:institution).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:department) }
    it { should normalize_attribute(:department).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:course) }
    it { should normalize_attribute(:course).from(' Nome   Completo  ').to('Nome Completo') }
  end

  context 'authors' do
    let(:thesis_ref) { Fabricate.build(:thesis_ref) }
    describe 'author' do
      it 'should have last name' do
        thesis_ref.first_author = 'firstname'
        expect(thesis_ref).not_to be_valid
        thesis_ref.first_author = 'firstname lastname'
        expect(thesis_ref).to be_valid
      end
    end
  end

  context 'citacoes' do
    let(:thesis_ref) { Fabricate.build(:thesis_ref).decorate }

    describe '#direct_citation' do

      it 'should include author' do
        last_name = UnicodeUtils.upcase(thesis_ref.first_author.split(' ').last)
        expect(thesis_ref.direct_citation).to include("#{last_name}")
      end

      it 'should include year' do
        expect(thesis_ref.direct_citation).to include(thesis_ref.year.to_s)
      end

      it 'should include (' do
        expect(thesis_ref.direct_citation).to include('(')
      end

      it 'should include )' do
        expect(thesis_ref.direct_citation).to include(')')
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
        expect(thesis_ref1).to receive(:check_equality)
        thesis_ref1.save!
      end

      it 'should invoke check_difference' do
        reference = Fabricate.build(:thesis_ref)
        reference.save!
        #expect(reference).to receive(:check_equality)

        @tcc = Fabricate(:tcc_with_all)
        @tcc.references.create!(element: reference)
        reference.reload
        @tcc.abstract.content = "<p>#{Faker::Lorem.paragraph(1)}
        #{ReferencesUtils::build_tag_citacao(reference.decorate,
                            'ci',
                            reference.decorate.indirect_citation)}
        #{Faker::Lorem.paragraph(1)}</p>"
        @tcc.abstract.save!
        @tcc.save!

        # changed reference
        reference.first_author = 'Autor A100'
        expect(reference).to receive(:check_difference)

        reference.save!
      end

      it 'subtype should be nil' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.first_author = 'Autor A1'
        thesis_ref1.second_author = ''
        thesis_ref1.third_author = ''

        thesis_ref1.save!

        expect(thesis_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.first_author = 'Autor A1'
        thesis_ref1.second_author = ''
        thesis_ref1.third_author = ''

        thesis_ref1.save!
        thesis_ref1.save!

        expect(thesis_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.first_author = 'Autor A1'
        thesis_ref1.second_author = ''
        thesis_ref1.third_author = ''

        thesis_ref1.save!

        thesis_ref2 = Fabricate.build(:thesis_ref)
        thesis_ref2.first_author = 'Autor A1'
        thesis_ref2.second_author = ''
        thesis_ref2.third_author = ''

        thesis_ref2.save!

        thesis_ref1.reload

        expect(thesis_ref1.subtype).to eq('a')
        expect(thesis_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        thesis_ref1 = Fabricate.build(:thesis_ref)
        thesis_ref1.first_author = 'Autor A1'
        thesis_ref1.second_author = ''
        thesis_ref1.third_author = ''

        thesis_ref1.save!

        thesis_ref2 = Fabricate.build(:thesis_ref)
        thesis_ref2.first_author = 'Autor A1'
        thesis_ref2.second_author = ''
        thesis_ref2.third_author = ''

        thesis_ref2.save!

        thesis_ref1.reload

        expect(thesis_ref1.subtype).to eq('a')
        expect(thesis_ref2.subtype).to eq('b')

        thesis_ref2
        thesis_ref2.first_author = 'Autor A10'
        thesis_ref2.save!
        thesis_ref1.reload
        thesis_ref2.reload

        expect(thesis_ref1.subtype).to be_nil
        expect(thesis_ref2.subtype).to be_nil

      end

    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:reference) { Fabricate(:thesis_ref) }
  end

  context 'authors' do
    it_should_behave_like 'authors with first and lastname' do
      let(:ref) { Fabricate(:thesis_ref) }
    end
  end

  context '#indirect_citation' do
    it_should_behave_like 'indirect_citation with more than one author' do
      let(:ref) { Fabricate(:thesis_ref) }
    end
  end

end
