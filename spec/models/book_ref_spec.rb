require 'spec_helper'

describe BookRef do
  context 'validations' do

    before(:all) do
      @book_ref = Fabricate(:book_ref)
    end

    after(:all) do
      @book_ref.destroy
    end

    it { should respond_to(:first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year) }
    it { should have_one(:reference) }

    # Pending
    it { should have_one(:tcc).through(:reference) }

    it { should validate_numericality_of(:year).only_integer }
    it { should validate_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should validate_inclusion_of(:type_quantity).in_array(BookRef::QUANTITY_TYPES) }

    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:publisher) }
  end

  describe '#edition_number' do
    it { should validate_numericality_of(:edition_number).only_integer }
    it { should_not allow_value(-1).for(:edition_number) }
    it { should_not allow_value(-5).for(:edition_number) }
    it { should_not allow_value(0).for(:edition_number) }
    it { should allow_value(1).for(:edition_number) }
    it { should allow_value(5).for(:edition_number) }
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
    it { should normalize_attribute(:local) }
    it { should normalize_attribute(:local).from(' Nome   Completo  ').to('Nome Completo') }
  end
  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        BookRef.destroy_all
      end

      it 'should invoke callback' do
        book_ref1 = Fabricate.build(:book_ref)
        expect(book_ref1).to receive(:check_equality)
        book_ref1.save!
      end

      it 'should invoke check_difference' do
        reference = Fabricate.build(:book_ref)
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
        book_ref1 = Fabricate.build(:book_ref)
        book_ref1.first_author = 'Autor A1'
        book_ref1.second_author = 'Autor A2'
        book_ref1.third_author = 'Autor A3'
        book_ref1.save!

        expect(book_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        book_ref1 = Fabricate.build(:book_ref)
        book_ref1.first_author = 'Autor A1'
        book_ref1.second_author = 'Autor A2'
        book_ref1.third_author = 'Autor A3'
        book_ref1.save!
        book_ref1.save!

        expect(book_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        book_ref1 = Fabricate.build(:book_ref)
        book_ref1.first_author = 'Autor A1'
        book_ref1.second_author = 'Autor A2'
        book_ref1.third_author = 'Autor A3'
        book_ref1.save!

        book_ref2 = Fabricate.build(:book_ref)
        book_ref2.first_author = 'Autor A1'
        book_ref2.second_author = 'Autor A2'
        book_ref2.third_author = 'Autor A3'
        book_ref2.save!

        book_ref1.reload

        expect(book_ref1.subtype).to eq('a')
        expect(book_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        book_ref1 = Fabricate.build(:book_ref)
        book_ref1.first_author = 'Autor A1'
        book_ref1.second_author = 'Autor A2'
        book_ref1.third_author = 'Autor A3'
        book_ref1.save!

        book_ref2 = Fabricate.build(:book_ref)
        book_ref2.first_author = 'Autor A1'
        book_ref2.second_author = 'Autor A2'
        book_ref2.third_author = 'Autor A3'
        book_ref2.save!

        book_ref1.reload

        expect(book_ref1.subtype).to eq('a')
        expect(book_ref2.subtype).to eq('b')

        book_ref2
        book_ref2.first_author = 'Autor A10'
        book_ref2.save!
        book_ref1.reload
        book_ref2.reload

        expect(book_ref1.subtype).to be_nil
        expect(book_ref2.subtype).to be_nil

      end

    end
  end

  context 'authors' do
    it_should_behave_like 'authors with first and lastname' do
      let(:ref) { Fabricate(:book_ref) }
    end
  end

  context '#indirect_citation' do
    it_should_behave_like 'indirect_citation with more than one author' do
      let(:ref) { Fabricate(:book_ref) }
    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:reference) { Fabricate(:book_ref) }
  end

end