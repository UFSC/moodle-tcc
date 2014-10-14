require 'spec_helper'

describe GenericReferenceDecorator do
  let!(:book_ref) { Fabricate(:book_ref) }
  let!(:book_cap_ref) { Fabricate(:book_cap_ref) }
  let!(:internet_ref) { Fabricate(:internet_ref) }
  let!(:article_ref) { Fabricate(:article_ref) }

  it 'should be properly decorate' do
    [book_ref, book_cap_ref, internet_ref, article_ref].each{ |ref|
      r = GenericReferenceDecorator.new(ref)
      expect(r.direct_citation).not_to be_nil
      expect(r.indirect_citation).not_to be_nil
    }
  end
end
