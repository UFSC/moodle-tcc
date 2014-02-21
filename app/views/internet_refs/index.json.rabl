object @internet_refs

attributes :id, :access_date, :publication_date, :first_author, :second_author,:third_author,:et_al, :subtitle,
           :title, :url
node(:display_message) { |internet_refs| "#{internet_refs.indirect_citation} - #{internet_refs.title}" }
node(:reference_id) { |internet_refs| internet_refs.reference.id }