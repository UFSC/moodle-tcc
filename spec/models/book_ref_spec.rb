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
    xit { should have_one(:tcc).through(:references) }

    it { should validate_numericality_of(:year).only_integer }
    it { should ensure_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should ensure_inclusion_of(:type_quantity).in_array(BookRef::QUANTITY_TYPES) }

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

end
