object @book_refs

attributes :id, :et_all, :first_author, :second_author, :third_author, :edition_number, :local, :type_quantity, :num_quantity, :title, :subtitle, :year, :publisher
node(:display_message) { |book_refs| book_refs.title }
node(:reference_id) { |book_refs| book_refs.reference.id }