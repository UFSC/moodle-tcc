object @book_cap_refs

attributes :id, :first_entire_author, :second_entire_author, :third_entire_author, :book_subtitle, :book_title,
           :first_part_author, :second_part_author, :third_part_author, :cap_subtitle, :cap_title, :end_page,
           :initial_page, :local, :publisher, :type_participation, :year, :et_al_part,:et_al_entire
node(:display_message) { |book_cap_refs| "#{book_cap_refs.indirect_citation} - #{book_cap_refs.book_title}" }
node(:reference_id) { |book_cap_refs| book_cap_refs.reference.id }