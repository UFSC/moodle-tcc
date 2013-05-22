require 'spec_helper'

describe BookRef do
  let(:book_ref) { Fabricate(:book_ref) }

  it { should respond_to(:first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year) }

  it { should have_one(:reference) }
  xit { should have_one(:tcc).through(:references) }

  it { should ensure_inclusion_of(:year).in_range(0..Date.today.year) }
  it { should validate_numericality_of(:year) }
  it { should ensure_inclusion_of(:type_quantity).in_array(%w(p, ed)) }
  it { should validate_presence_of(:first_author) }
  it { should validate_presence_of(:edition_number) }
  it { should validate_presence_of(:local) }
  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:publisher) }
end
