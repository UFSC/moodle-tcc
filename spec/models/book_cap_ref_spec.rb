require 'spec_helper'

describe BookCapRef do
  context 'validations' do
    before(:all) { @book_cap_ref = Fabricate(:book_cap_ref) }
    after(:all) { @book_cap_ref.destroy }

    it { should respond_to(:book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year) }
    it { should have_one(:reference) }

    # Pending
    it { should have_one(:tcc).through(:reference) }

    it { should validate_numericality_of(:year).only_integer }
    it { should ensure_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should ensure_inclusion_of(:type_participation).in_array(BookCapRef::PARTICIPATION_TYPES) }
    it { should validate_numericality_of(:year) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:publisher) }
    it { should validate_presence_of(:cap_title) }
    it { should validate_presence_of(:cap_author) }
    it { should validate_presence_of(:book_title) }
    it { should validate_presence_of(:book_author) }
    it { should validate_presence_of(:type_participation) }
    it { should validate_presence_of(:initial_page) }
    it { should validate_numericality_of(:initial_page) }
    it { should validate_presence_of(:end_page) }
    it { should validate_numericality_of(:end_page) }
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
      book_cap_ref.should_not be_valid
      book_cap_ref.end_page = 10
      book_cap_ref.should be_valid
      book_cap_ref.end_page = 5
      book_cap_ref.should be_valid
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
end
