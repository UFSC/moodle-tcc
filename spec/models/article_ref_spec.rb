require 'spec_helper'

describe ArticleRef do
  context 'validations' do
    before(:all) { @article_ref = Fabricate(:article_ref) }
    after(:all) { @article_ref.destroy }

    it { should respond_to(:article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name, :local, :number_or_fascicle, :year, :second_author, :third_author, :volume_number) }
    it { should have_one(:reference) }

    # Pending
    it { should have_one(:tcc).through(:reference) }

    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:article_title) }
    it { should validate_presence_of(:journal_name) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should ensure_inclusion_of(:year).in_range(0..(Date.today.year)) }
    it { should validate_presence_of(:initial_page) }
    it { should validate_presence_of(:end_page) }
  end

  describe '#volume_number' do
    it { should validate_numericality_of(:volume_number).only_integer }
    it { should_not allow_value(-1).for(:volume_number) }
    it { should_not allow_value(-5).for(:volume_number) }
    it { should_not allow_value(0).for(:volume_number) }
    it { should allow_value(1).for(:volume_number) }
    it { should allow_value(5).for(:volume_number) }
  end

  describe '#number_or_fascicle' do
    it { should validate_numericality_of(:number_or_fascicle).only_integer }
    it { should_not allow_value(-1).for(:number_or_fascicle) }
    it { should_not allow_value(-5).for(:number_or_fascicle) }
    it { should_not allow_value(0).for(:number_or_fascicle) }
    it { should allow_value(1).for(:number_or_fascicle) }
    it { should allow_value(5).for(:number_or_fascicle) }
  end

  describe '#initial_page' do
    it { should validate_numericality_of(:initial_page).only_integer }
    it { should_not allow_value(-1).for(:initial_page) }
    it { should_not allow_value(-5).for(:initial_page) }
    it { should_not allow_value(0).for(:initial_page) }
    it { should allow_value(1).for(:initial_page) }
    it { should allow_value(5).for(:initial_page) }

    it 'should be lower than #end_page' do
      article_ref = Fabricate.build(:article_ref)
      article_ref.initial_page = 5
      article_ref.end_page = 2
      article_ref.should_not be_valid
      article_ref.end_page = 10
      article_ref.should be_valid
      article_ref.end_page = 5
      article_ref.should be_valid
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
