require 'spec_helper'

describe BookRef do
  let(:book_ref) { Fabricate(:book_ref) }

  it { should respond_to(:first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year) }

  it { should have_one(:reference) }
  xit { should have_one(:tcc).through(:references) }

  it { should validate_presence_of(:first_author) }
  it { should validate_presence_of(:edition_number) }
  it { should validate_presence_of(:local) }
  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:publisher) }
end
