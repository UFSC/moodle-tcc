object @thesis_refs

attributes :id, :author, :title, :subtitle, :local, :year, :chapter, :type_thesis, :type_number,
:pages_or_volumes_number, :degree, :institution, :year_of_submission, :course, :department
node(:display_message) { |thesis_refs| "#{thesis_refs.indirect_citation} - #{thesis_refs.title}" }
node(:reference_id) { |thesis_refs| thesis_refs.reference.id }
