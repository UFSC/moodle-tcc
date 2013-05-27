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
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:total_pages) }

  end
end
