require 'spec_helper'

describe InternetRef do
  context 'validations' do

    before(:all) do
      @internet_ref = Fabricate(:internet_ref)
    end

    after(:all) do
      @internet_ref.destroy
    end


    it { should respond_to(:access_date, :first_author, :second_author, :third_author, :publication_date, :et_al,
                           :complementary_information, :subtitle,
                           :title,
                           :url) }
    it { should have_one(:reference) }


    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:access_date) }

    it { should allow_value(Date.yesterday).for(:access_date) }
    it { should allow_value(Date.today).for(:access_date) }
    it { should_not allow_value(Date.tomorrow).for(:access_date) }

    describe '#url' do
      it { should validate_presence_of(:url) }
      it { should_not allow_value('abcd').for(:url) }
      it { should_not allow_value('domain.com').for(:url) }
      it { should_not allow_value('http://').for(:url) }
      it { should_not allow_value('http://domain.c/path/file.ext').for(:url) }
      it { should allow_value('http://domain.com').for(:url) }
      it { should allow_value('http://domain.com/').for(:url) }
      it { should allow_value('http://domain.com/path').for(:url) }
      it { should allow_value('http://domain.com/path/file.ext').for(:url) }
      it { should allow_value('https://domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://user@domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://user:pass@domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftps://domain.com/path/file.ext').for(:url) }
      it { should allow_value('http://200.200.1.1/test/test%20de%20arquivo.ext').for(:url) }
      it { should allow_value('http://200.20.1.1/test/test%20de%20arquivo.ext').for(:url) }
      it { should allow_value('http://200.200.1.1/test/test%20de%20arquivo.super.ext').for(:url) }
    end

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
  end
  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        InternetRef.destroy_all
      end

      it 'should invoke callback' do
        internet_ref1 = Fabricate.build(:internet_ref)
        expect(internet_ref1).to receive(:check_equality)
        internet_ref1.save!
      end

      it 'should invoke check_difference' do
        reference = Fabricate.build(:internet_ref)
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
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.first_author = 'Autor A1'
        internet_ref1.second_author = 'Autor A2'
        internet_ref1.third_author = 'Autor A3'

        internet_ref1.save!

        expect(internet_ref1.subtype).to be_nil
      end

      it 'subtype should be nil after one update' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.first_author = 'Autor A1'
        internet_ref1.second_author = 'Autor A2'
        internet_ref1.third_author = 'Autor A3'

        internet_ref1.save!
        internet_ref1.save!

        expect(internet_ref1.subtype).to be_nil
      end

      it 'subtype should be set correctly' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.first_author = 'Autor A1'
        internet_ref1.second_author = 'Autor A2'
        internet_ref1.third_author = 'Autor A3'
        internet_ref1.save!

        internet_ref2 = Fabricate.build(:internet_ref)
        internet_ref2.first_author = 'Autor A1'
        internet_ref2.second_author = 'Autor A2'
        internet_ref2.third_author = 'Autor A3'

        internet_ref2.save!

        internet_ref1.reload

        expect(internet_ref1.subtype).to eq('a')
        expect(internet_ref2.subtype).to eq('b')

      end

      it 'should set subtype to nil if object is different' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.first_author = 'Autor A1'
        internet_ref1.second_author = 'Autor A2'
        internet_ref1.third_author = 'Autor A3'
        internet_ref1.save!

        internet_ref2 = Fabricate.build(:internet_ref)
        internet_ref2.first_author = 'Autor A1'
        internet_ref2.second_author = 'Autor A2'
        internet_ref2.third_author = 'Autor A3'
        internet_ref2.save!

        internet_ref1.reload

        expect(internet_ref1.subtype).to eq('a')
        expect(internet_ref2.subtype).to eq('b')

        internet_ref2
        internet_ref2.first_author = 'Autor A10'
        internet_ref2.save!
        internet_ref1.reload
        internet_ref2.reload

        expect(internet_ref1.subtype).to be_nil
        expect(internet_ref2.subtype).to be_nil

      end

    end
  end

  context '#year' do
    let(:internet_ref) { Fabricate(:internet_ref) }
    it 'should display publication date instead of acess date' do
      internet_ref.publication_date = '2012-05-05'
      internet_ref.access_date = '2013-05-05'
      expect(internet_ref.year).to eq(2012)
      expect(internet_ref.year).not_to eq(2013)
    end
    it 'should display access date when publication date is nil' do
      internet_ref.publication_date = nil
      internet_ref.access_date = '2013-05-05'
      expect(internet_ref.year).to eq(2013)
    end
  end

  context '#indirect_citation' do
    it_should_behave_like 'indirect_citation with more than one author' do
      let(:ref) { Fabricate(:internet_ref) }
    end
  end

  it_should_behave_like 'references with citations in the text' do
    let(:reference) { Fabricate(:internet_ref) }
  end

end
