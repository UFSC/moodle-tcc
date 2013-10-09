object @internet_ref

attributes :id, :access_date, :author, :subtitle, :title, :url
node(:display_message) { |internet_ref| internet_ref.title }
node(:direct_citation) { |internet_ref| internet_ref.direct_citation }
node(:indirect_citation) { |internet_ref| internet_ref.indirect_citation }
