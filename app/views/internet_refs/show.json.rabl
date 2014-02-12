object @internet_ref

attributes :id, :access_date, :ref_date, :first_author, :second_author,:third_author,:et_al, :subtitle, :title, :url
node(:display_message) { |internet_ref| internet_ref.title }
node(:direct_citation) { |internet_ref| internet_ref.direct_citation }
node(:indirect_citation) { |internet_ref| internet_ref.indirect_citation }
node(:reference_id) { |internet_ref| internet_ref.reference.id }