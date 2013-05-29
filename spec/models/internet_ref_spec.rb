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
      it { should allow_value('http://domain.com').for(:url) }
      it { should allow_value('http://domain.com/').for(:url) }
      it { should allow_value('http://domain.com/path').for(:url) }
      it { should allow_value('http://domain.com/path/file.ext').for(:url) }
      it { should allow_value('https://domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://user@domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftp://user:pass@domain.com/path/file.ext').for(:url) }
      it { should allow_value('ftps://domain.com/path/file.ext').for(:url) }
    end

  end
end
