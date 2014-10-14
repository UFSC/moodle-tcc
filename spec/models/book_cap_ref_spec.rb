require 'spec_helper'

describe BookCapRef do
  context 'validations' do
    before(:all) { @book_cap_ref = Fabricate(:book_cap_ref) }
    after(:all) { @book_cap_ref.destroy }

    it { should respond_to(:et_al_entire, :et_al_part, :book_subtitle, :book_title, :cap_subtitle, :cap_title,
                           :first_part_author, :second_part_author, :third_part_author,
                           :first_entire_author, :second_entire_author, :third_entire_author,
                           :end_page, :initial_page, :local, :publisher, :type_participation, :year) }

    it { should have_one(:reference) }

    # Pending
    it { should have_one(:tcc).through(:reference) }

    it { should validate_numericality_of(:year).only_integer }
    it { should validate_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should validate_inclusion_of(:type_participation).in_array(BookCapRef::PARTICIPATION_TYPES) }
    it { should validate_numericality_of(:year) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:publisher) }
    it { should validate_presence_of(:cap_title) }
    it { should validate_presence_of(:first_part_author) }
    it { should validate_presence_of(:book_title) }
    it { should validate_presence_of(:first_entire_author) }
    it { should validate_presence_of(:type_participation) }
    it { should validate_presence_of(:initial_page) }
    it { should validate_numericality_of(:initial_page) }
    it { should validate_presence_of(:end_page) }
    it { should validate_numericality_of(:end_page) }
  end

  context 'authors' do
    let(:book_cap_ref) { Fabricate.build(:book_cap_ref) }

    describe 'first_entire_author' do
      it 'should have last name' do
        book_cap_ref.first_entire_author = 'firstname'
        expect(book_cap_ref).not_to be_valid
        book_cap_ref.first_entire_author = 'firstname lastname'
        expect(book_cap_ref).to be_valid
      end
    end

    describe 'second_entire_author' do
      it 'should have last name' do
        book_cap_ref.second_entire_author = 'firstname'
        expect(book_cap_ref).not_to be_valid
        book_cap_ref.second_entire_author = 'firstname lastname'
        expect(book_cap_ref).to be_valid
      end
    end

    describe 'third_entire_author' do
      it 'should have last name' do
        book_cap_ref.third_entire_author = 'firstname'
        expect(book_cap_ref).not_to be_valid
        book_cap_ref.third_entire_author = 'firstname lastname'
        expect(book_cap_ref).to be_valid
      end
    end

    it_should_behave_like "authors with first and lastname" do
      let(:ref) { Fabricate(:book_cap_ref) }
    end
  end

  context 'normalizations' do
    it { should normalize_attribute(:first_entire_author) }
    it { should normalize_attribute(:first_entire_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:second_entire_author) }
    it { should normalize_attribute(:second_entire_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:third_entire_author) }
    it { should normalize_attribute(:third_entire_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:first_part_author) }
    it { should normalize_attribute(:first_part_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:second_part_author) }
    it { should normalize_attribute(:second_part_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:third_part_author) }
    it { should normalize_attribute(:third_part_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:book_title) }
    it { should normalize_attribute(:book_title).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:local) }
    it { should normalize_attribute(:local).from(' Nome   Completo  ').to('Nome Completo') }
  end

  describe '#initial_page' do
    it { should validate_numericality_of(:initial_page).only_integer }
    it { should_not allow_value(-1).for(:initial_page) }
    it { should_not allow_value(-5).for(:initial_page) }
    it { should_not allow_value(0).for(:initial_page) }
    it { should allow_value(1).for(:initial_page) }
    it { should allow_value(5).for(:initial_page) }

    it 'should have to be lower then #end_page' do
      book_cap_ref = Fabricate.build(:book_cap_ref)
      book_cap_ref.initial_page = 5
      book_cap_ref.end_page = 2
      expect(book_cap_ref).not_to be_valid
      book_cap_ref.end_page = 10
      expect(book_cap_ref).to be_valid
      book_cap_ref.end_page = 5
      expect(book_cap_ref).to be_valid
    end

  end

  describe '#end_page' do
    it { should validate_numericality_of(:end_page).only_integer }
    it { should_not allow_value(-1).for(:end_page) }
    it { should_not allow_value(-5).for(:end_page) }
    it { should_not allow_value(0).for(:end_page) }
    it { should allow_value(1).for(:end_page) }
    it { should allow_value(5).for(:end_page) }
  end


  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        BookCapRef.destroy_all
      end

      it 'should invoke callback' do
        book_cap_ref1 = Fabricate.build(:book_cap_ref)
        expect(book_cap_ref1).to receive(:check_equality)
        book_cap_ref1.save!
      end

      it 'subtype should be nil' do
        book_cap_ref1 = Fabricate.build(:book_cap_ref)
        book_cap_ref1.first_entire_author = 'Autor A1'

        book_cap_ref1.save!

        expect(book_cap_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        book_cap_ref1 = Fabricate.build(:book_cap_ref)
        book_cap_ref1.first_entire_author = 'Autor A1'

        book_cap_ref1.save!
        book_cap_ref1.save!

        expect(book_cap_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        book_cap_ref1 = Fabricate.build(:book_cap_ref)
        book_cap_ref1.first_entire_author = 'Autor A1'
        book_cap_ref1.second_entire_author = 'Autor A2'
        book_cap_ref1.third_entire_author = 'Autor A3'

        book_cap_ref1.save!

        book_cap_ref2 = Fabricate.build(:book_cap_ref)
        book_cap_ref2.first_entire_author = 'Autor A1'
        book_cap_ref2.second_entire_author = 'Autor A2'
        book_cap_ref2.third_entire_author = 'Autor A3'

        book_cap_ref2.save!

        book_cap_ref1.reload

        expect(book_cap_ref1.subtype).to eq('a')
        expect(book_cap_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        book_cap_ref1 = Fabricate.build(:book_cap_ref)
        book_cap_ref1.first_entire_author = 'Autor A1'
        book_cap_ref1.second_entire_author = 'Autor A2'
        book_cap_ref1.third_entire_author = 'Autor A3'

        book_cap_ref1.save!

        book_cap_ref2 = Fabricate.build(:book_cap_ref)
        book_cap_ref2.first_entire_author = 'Autor A1'
        book_cap_ref2.second_entire_author = 'Autor A2'
        book_cap_ref2.third_entire_author = 'Autor A3'

        book_cap_ref2.save!

        book_cap_ref1.reload

        expect(book_cap_ref1.subtype).to eq('a')
        expect(book_cap_ref2.subtype).to eq('b')

        book_cap_ref2
        book_cap_ref2.first_entire_author = 'Autor A10'
        book_cap_ref2.save!
        book_cap_ref1.reload
        book_cap_ref2.reload

        expect(book_cap_ref1.subtype).to be_nil
        expect(book_cap_ref2.subtype).to be_nil

      end

    end
  end
  context '#indirect_citation' do
    it_should_behave_like "indirect_citation with more than one author" do
      let(:ref) { Fabricate(:book_cap_ref) }
    end
  end
  it_should_behave_like 'references with citations in the text' do
    let(:ref) { Fabricate.build(:book_cap_ref) }
  end
end
