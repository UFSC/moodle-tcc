require 'spec_helper'

describe LegislativeRef do
  context 'validations' do

    it { should respond_to(:edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year) }
    it { should have_one(:reference) }

    it { should validate_presence_of(:jurisdiction_or_header) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:edition) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:publisher) }
    it { should validate_presence_of(:total_pages) }
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
    it { should ensure_inclusion_of(:year).in_range(0..(Date.today.year)) }
  end
end
