object @book_cap_ref

attributes :id, :book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year
node(:display_message) { |book_cap_ref| book_cap_ref.book_title}
node(:direct_citation) { |book_cap_ref| book_cap_ref.direct_citation}
node(:indirect_citation) { |book_cap_ref| book_cap_ref.indirect_citation}
node(:reference_id) { |book_cap_ref| book_cap_ref.reference.id }