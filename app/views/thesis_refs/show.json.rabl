object @thesis_ref

attributes :id, :first_author, :second_author, :third_author, :et_all, :title, :subtitle, :local, :year, :chapter,
           :type_thesis, :type_number,
:pages_or_volumes_number, :degree, :institution, :year_of_submission, :course, :department
node(:display_message) { |thesis_ref| thesis_ref.title}
node(:direct_citation) { |thesis_ref| thesis_ref.direct_citation}
node(:indirect_citation) { |thesis_ref| thesis_ref.indirect_citation}
node(:reference_id) { |thesis_ref| thesis_ref.reference.id }