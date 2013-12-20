<<<<<<< HEAD
object @thesis_refs

attributes :id, :author, :title, :subtitle, :local, :year, :chapter, :type_thesis, :type_number,
:pages_or_volumes_number, :degree, :institution, :year_of_submission, :course, :department
node(:display_message) { |thesis_refs| "#{thesis_refs.indirect_citation} - #{thesis_refs.title}" }
node(:reference_id) { |thesis_refs| thesis_refs.reference.id }
=======
object @book_cap_refs

attributes :id, :book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year
node(:display_message) { |book_cap_refs| "#{book_cap_refs.indirect_citation} - #{book_cap_refs.book_title}" }
node(:reference_id) { |book_cap_refs| book_cap_refs.reference.id }
>>>>>>> b312b31d39ff27e7bbe1f822a96b99e301dc48e7
