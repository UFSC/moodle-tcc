object @book_cap_ref

attributes :id, :first_entire_author, :second_entire_author, :third_entire_author, :book_subtitle, :book_title,
           :first_part_author, :second_part_author, :third_part_author, :cap_subtitle, :cap_title, :end_page,
           :initial_page, :local, :publisher, :type_participation, :year
node(:display_message) { |book_cap_ref| book_cap_ref.book_title }
node(:direct_citation) { |book_cap_ref| book_cap_ref.direct_citation }
node(:indirect_citation) { |book_cap_ref| book_cap_ref.indirect_citation }
node(:reference_id) { |book_cap_ref| book_cap_ref.reference.id }