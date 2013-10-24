object @book_ref

attributes :id, :et_all, :first_author, :second_author, :third_author, :edition_number, :local, :type_quantity, :num_quantity, :title, :subtitle, :year, :publisher
node(:display_message) { |book_ref| book_ref.title }
node(:direct_citation) { |book_ref| book_ref.direct_citation }
node(:indirect_citation) { |book_ref| book_ref.indirect_citation }
node(:reference_id) { |book_ref| book_ref.reference.id }