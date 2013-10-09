object @general_ref

attributes :id, :direct_citation, :indirect_citation
node(:reference_text) { |general_ref| sanitize(general_ref.reference_text, tags: []) }
node(:display_message) { |general_ref| sanitize(general_ref.reference_text, tags: []) }
