# encoding: utf-8
require 'spec_helper'

describe LegislativeRef do
  context 'validations' do
    before(:all) { @legislative_ref = Fabricate(:legislative_ref) }
    after(:all) { @legislative_ref.destroy }

    it { should respond_to(:edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year) }
    it { should have_one(:reference) }

    it { should validate_presence_of(:jurisdiction_or_header) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:edition) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:publisher) }
    it { should validate_presence_of(:total_pages) }
  end
  context 'normalizations' do
    it { should normalize_attribute(:jurisdiction_or_header) }
    it { should normalize_attribute(:jurisdiction_or_header).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:title) }
    it { should normalize_attribute(:title).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:local) }
    it { should normalize_attribute(:local).from(' Nome   Completo  ').to('Nome Completo') }
  end
  describe '#edition' do
    it { should validate_numericality_of(:edition).only_integer }
    it { should_not allow_value(-1).for(:edition) }
    it { should_not allow_value(-5).for(:edition) }
    it { should_not allow_value(0).for(:edition) }
    it { should allow_value(1).for(:edition) }
    it { should allow_value(5).for(:edition) }
  end

  describe '#total_pages' do
    it { should validate_numericality_of(:total_pages).only_integer }
    it { should_not allow_value(-1).for(:total_pages) }
    it { should_not allow_value(-5).for(:total_pages) }
    it { should_not allow_value(0).for(:total_pages) }
    it { should allow_value(1).for(:total_pages) }
    it { should allow_value(5).for(:total_pages) }
  end

  describe '#year' do
    it { should validate_presence_of(:year) }
    it { should validate_numericality_of(:year).only_integer }
    it { should validate_inclusion_of(:year).in_range(0..(Date.today.year)) }
  end

  context 'same_publisher' do
    describe '#check_equality' do
      after(:each) do
        LegislativeRef.destroy_all
      end

      it 'should invoke callback' do
        legislative_ref1 = Fabricate.build(:legislative_ref)
        expect(legislative_ref1).to receive(:check_equality)
        legislative_ref1.save!
      end

      it 'should invoke check_difference' do
        reference = Fabricate.build(:legislative_ref)
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
        reference.publisher = 'Autor A100'
        expect(reference).to receive(:check_difference)

        reference.save!
      end

      it 'subtype should be nil' do
        legislative_ref1 = Fabricate.build(:legislative_ref)
        legislative_ref1.publisher = 'Autor A1'

        legislative_ref1.save!

        expect(legislative_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        legislative_ref1 = Fabricate.build(:legislative_ref)
        legislative_ref1.publisher = 'Autor A1'

        legislative_ref1.save!
        legislative_ref1.save!

        expect(legislative_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        legislative_ref1 = Fabricate.build(:legislative_ref)
        legislative_ref1.publisher = 'Autor A1'

        legislative_ref1.save!

        legislative_ref2 = Fabricate.build(:legislative_ref)
        legislative_ref2.publisher = 'Autor A1'

        legislative_ref2.save!

        legislative_ref1.reload

        expect(legislative_ref1.subtype).to eq('a')
        expect(legislative_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        legislative_ref1 = Fabricate.build(:legislative_ref)
        legislative_ref1.publisher = 'Autor A1'

        legislative_ref1.save!

        legislative_ref2 = Fabricate.build(:legislative_ref)
        legislative_ref2.publisher = 'Autor A1'

        legislative_ref2.save!

        legislative_ref1.reload

        expect(legislative_ref1.subtype).to eq('a')
        expect(legislative_ref2.subtype).to eq('b')

        legislative_ref2
        legislative_ref2.publisher = 'Autor A10'
        legislative_ref2.save!
        legislative_ref1.reload
        legislative_ref2.reload

        expect(legislative_ref1.subtype).to be_nil
        expect(legislative_ref2.subtype).to be_nil

      end

    end
  end

  context '#direct_citation' do
    let(:ref) { Fabricate(:legislative_ref).decorate }

    it 'should capitalize jurisdiction' do
      expect(ref.direct_citation).to include(UnicodeUtils.upcase(ref.jurisdiction_or_header))
    end

    it 'should respect the direct citation format' do
      ref.jurisdiction_or_header = 'são paulo'
      ref.year = '2009'
      expect(ref.direct_citation).to eq('(SÃO PAULO, 2009)')
    end
  end

  context '#indirect_citation' do
    let(:ref) { Fabricate(:legislative_ref).decorate }

    it 'should capitalize jurisdiction as a title' do
      expect(ref.indirect_citation).to include(UnicodeUtils.titlecase(ref.jurisdiction_or_header))
    end

    it 'should respect the indirect citation format' do
      ref.jurisdiction_or_header = 'SÃO PAULO'
      ref.year = '2009'
      expect(ref.indirect_citation).to eq('São Paulo (2009)')
    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:reference) { Fabricate(:legislative_ref) }
  end

end
