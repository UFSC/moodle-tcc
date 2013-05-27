require 'spec_helper'

describe InternetRef do

  context 'validations' do
    before(:all) do
      @internet_ref = Fabricate(:internet_ref)
    end

    after(:all) do
      @internet_ref.destroy
    end

    it { should respond_to(:access_date, :author, :subtitle, :title, :url) }
    it { should have_one(:reference) }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:access_date) }

  end
end
