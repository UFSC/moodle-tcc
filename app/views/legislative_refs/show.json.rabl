object @legislative_ref

attributes :id, :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year
node(:display_message) { |legislative_ref| legislative_ref.jurisdiction_or_header}
node(:direct_citation) { |legislative_ref| legislative_ref.direct_citation}
node(:indirect_citation) { |legislative_ref| legislative_ref.indirect_citation}
node(:reference_id) { |legislative_ref| legislative_ref.reference.id }