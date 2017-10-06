require 'spec_helper'

describe ArticleRef do
  context 'validations' do
    before(:all) { @article_ref = Fabricate(:article_ref) }
    after(:all) { @article_ref.destroy }

    it { should respond_to(:article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name, :local, :number_or_fascicle, :year, :second_author, :third_author, :volume_number) }
    it { should have_one(:reference) }

    it { should have_one(:tcc).through(:reference) }

    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:article_title) }
    it { should validate_presence_of(:journal_name) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:initial_page) }
    it { should validate_presence_of(:end_page) }

  end

  context 'normalizations' do
    it { should normalize_attribute(:first_author) }
    it { should normalize_attribute(:first_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:second_author) }
    it { should normalize_attribute(:second_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:third_author) }
    it { should normalize_attribute(:third_author).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:journal_name) }
    it { should normalize_attribute(:journal_name).from(' Nome   Completo  ').to('Nome Completo') }
    it { should normalize_attribute(:local) }
    it { should normalize_attribute(:local).from(' Nome   Completo  ').to('Nome Completo') }
  end

  context 'authors' do
    it_should_behave_like "authors with first and lastname" do
      let(:ref) { Fabricate(:article_ref) }
    end
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
      expect(article_ref).not_to be_valid
      article_ref.end_page = 10
      expect(article_ref).to be_valid
      article_ref.end_page = 5
      expect(article_ref).to be_valid
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

  context 'citacoes' do
    let(:article_ref) { GenericReferenceDecorator.new(Fabricate.build(:article_ref)) }

    describe '#direct_citation' do

      it 'should include first_author' do
        last_name = UnicodeUtils.upcase(article_ref.first_author.split(' ').last)
        expect(article_ref.direct_citation).to include("#{last_name};")
      end
      it 'should include second_author' do
        last_name = UnicodeUtils.upcase(article_ref.second_author.split(' ').last)
        expect(article_ref.direct_citation).to include("#{last_name};")
      end
      it 'should include third_author' do
        last_name = UnicodeUtils.upcase(article_ref.third_author.split(' ').last)
        expect(article_ref.direct_citation).to include("#{last_name},")
      end

      it 'should include year' do
        expect(article_ref.direct_citation).to include(article_ref.year.to_s)
      end

      it 'should include (' do
        expect(article_ref.direct_citation).to include('(')
      end

      it 'should include )' do
        expect(article_ref.direct_citation).to include(')')
      end

    end

  end

  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        ArticleRef.destroy_all
      end

      it 'should invoke check_equality' do
        article_ref1 = Fabricate.build(:article_ref)
        expect(article_ref1).to receive(:check_equality)

        article_ref1.save!
      end

      it 'should invoke check_difference' do
        reference = Fabricate.build(:article_ref)
        reference.save!
        #expect(reference).to receive(:check_equality)

        @tcc = Fabricate(:tcc_with_all)
        @tcc.references.create!(element: reference)
        reference.reload
        @tcc.abstract.content = "<p>#{Faker::Lorem.paragraph(1)}#{ReferencesUtils::build_tag_citacao(reference.decorate,'ci',
                                        reference.decorate.indirect_citation)}#{Faker::Lorem.paragraph(1)}</p>"
        @tcc.abstract.save!
        @tcc.save!

        # changed reference
        reference.first_author = 'Autor A100'
        expect(reference).to receive(:check_difference)

        reference.save!
      end

      it 'subtype should be nil' do
        article_ref1 = Fabricate.build(:article_ref)
        article_ref1.first_author = 'Autor A1'
        article_ref1.second_author = 'Autor A2'
        article_ref1.third_author = 'Autor A3'
        article_ref1.save!

        expect(article_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        article_ref1 = Fabricate.build(:article_ref)
        article_ref1.first_author = 'Autor A1'
        article_ref1.second_author = 'Autor A2'
        article_ref1.third_author = 'Autor A3'
        article_ref1.save!
        article_ref1.save!

        expect(article_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        article_ref1 = Fabricate.build(:article_ref)
        article_ref1.first_author = 'Autor A1'
        article_ref1.second_author = 'Autor A2'
        article_ref1.third_author = 'Autor A3'
        article_ref1.save!

        article_ref2 = Fabricate.build(:article_ref)
        article_ref2.first_author = 'Autor A1'
        article_ref2.second_author = 'Autor A2'
        article_ref2.third_author = 'Autor A3'
        article_ref2.save!

        article_ref1.reload

        expect(article_ref1.subtype).to eq('a')
        expect(article_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        article_ref1 = Fabricate.build(:article_ref)
        article_ref1.first_author = 'Autor A1'
        article_ref1.second_author = 'Autor A2'
        article_ref1.third_author = 'Autor A3'
        article_ref1.save!

        article_ref2 = Fabricate.build(:article_ref)
        article_ref2.first_author = 'Autor A1'
        article_ref2.second_author = 'Autor A2'
        article_ref2.third_author = 'Autor A3'
        article_ref2.save!

        article_ref1.reload

        expect(article_ref1.subtype).to eq('a')
        expect(article_ref2.subtype).to eq('b')

        article_ref2
        article_ref2.first_author = 'Autor A10'
        article_ref2.save!
        article_ref2.reload
        article_ref1.reload

        expect(article_ref1.subtype).to be_nil
        expect(article_ref2.subtype).to be_nil

      end

    end
  end

  context '#indirect_citation' do
    it_should_behave_like 'indirect_citation with more than one author' do
      let(:ref) { Fabricate.build(:article_ref) }
    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:reference) { Fabricate(:article_ref) }
  end

end
