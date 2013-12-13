object @general_refs

attributes :id, :direct_citation, :indirect_citation
node(:reference_text) { |general_refs| sanitize(general_refs.reference_text, tags: []) }
node(:display_message) { |general_refs| sanitize(general_refs.indirect_citation, tags: []) }
node(:reference_id) { |general_refs| general_refs.reference.id }