object @internet_refs

attributes :id, :access_date, :author, :subtitle, :title, :url
node(:display_message) { |internet_refs| internet_refs.indirect_citation }
node(:reference_id) { |internet_refs| internet_refs.reference.id }