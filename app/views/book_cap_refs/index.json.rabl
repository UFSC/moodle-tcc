object @book_cap_refs

attributes :id, :book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year
node(:display_message) { |book_cap_refs| book_cap_refs.book_title}