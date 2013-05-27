require 'spec_helper'

describe BookCapRef do
  context 'validations' do
    before(:all) do
      @book_cap_ref = Fabricate(:book_cap_ref)
    end

    after(:all) do
      @book_cap_ref.destroy
    end

    it { should respond_to(:book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :inicial_page, :local, :publisher, :type_participation, :year) }
    it { should have_one(:reference) }

    # Pending
    xit { should have_one(:tcc).through(:references) }

    it { should ensure_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should ensure_inclusion_of(:type_participation).in_array(%w(Autor Organizador Compilador Editor)) }
    it { should validate_numericality_of(:year) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:publisher) }
    it { should validate_presence_of(:cap_title) }
    it { should validate_presence_of(:cap_author) }
    it { should validate_presence_of(:book_title) }
    it { should validate_presence_of(:book_author) }
    it { should validate_presence_of(:type_participation) }
    it { should validate_presence_of(:inicial_page) }
    it { should validate_numericality_of(:inicial_page) }
    it { should validate_presence_of(:end_page) }
    it { should validate_numericality_of(:end_page) }

  end
end
