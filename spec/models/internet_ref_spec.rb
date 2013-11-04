require 'spec_helper'

describe InternetRef do

  context 'validations' do
    before(:all) { @internet_ref = Fabricate(:internet_ref) }
    after(:all) { @internet_ref.destroy }

    it { should respond_to(:access_date, :author, :subtitle, :title, :url) }
    it { should have_one(:reference) }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:access_date) }

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

  context 'same_author' do
    describe '#check_equality' do
      after(:each) do
        InternetRef.destroy_all
      end

      it 'should invoke callback' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.should_receive(:check_equality)
        internet_ref1.save!
      end

      it 'subtype should be nil' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.author = 'Autor A1'

        internet_ref1.save!

        internet_ref1.subtype.should be_nil
      end

      it 'subtype should be nil after one update' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.author = 'Autor A1'

        internet_ref1.save!
        internet_ref1.save!

        internet_ref1.subtype.should be_nil
      end

      it 'subtype should be set correctly' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.author = 'Autor A1'

        internet_ref1.save!

        internet_ref2 = Fabricate.build(:internet_ref)
        internet_ref2.author = 'Autor A1'

        internet_ref2.save!

        internet_ref1.reload

        internet_ref1.subtype.should == 'a'
        internet_ref2.subtype.should == 'b'

      end

      it 'should set subtype to nil if object is different' do
        internet_ref1 = Fabricate.build(:internet_ref)
        internet_ref1.author = 'Autor A1'

        internet_ref1.save!

        internet_ref2 = Fabricate.build(:internet_ref)
        internet_ref2.author = 'Autor A1'

        internet_ref2.save!

        internet_ref1.reload

        internet_ref1.subtype.should == 'a'
        internet_ref2.subtype.should == 'b'

        internet_ref2
        internet_ref2.author = 'Autor A10'
        internet_ref2.save!
        internet_ref1.reload
        internet_ref2.reload

        internet_ref1.subtype.should be_nil
        internet_ref2.subtype.should be_nil

      end

    end
  end


end
