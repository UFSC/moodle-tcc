require 'spec_helper'

describe ArticleRef do
  context 'validations' do
    before(:all) do
      @article_ref = Fabricate(:article_ref)
    end

    after(:all) do
      @article_ref.destroy
    end

    it { should respond_to(:article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name, :local, :number_or_fascicle, :publication_date, :second_author, :third_author, :volume_number) }
    it { should have_one(:reference) }

    # Pending
    xit { should have_one(:tcc).through(:references) }

    it { should validate_presence_of(:first_author) }
    it { should validate_presence_of(:article_title) }
    it { should validate_presence_of(:journal_name) }
    it { should validate_presence_of(:local) }
    it { should validate_presence_of(:publication_date) }
    it { should validate_presence_of(:initial_page) }
    it { should validate_presence_of(:end_page) }

  end
end
