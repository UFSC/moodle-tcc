object @legislative_refs

attributes :id, :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year
node(:display_message) { |legislative_refs| "#{legislative_refs.indirect_citation} - #{legislative_refs.title}" }
node(:reference_id) { |legislative_refs| legislative_refs.reference.id }