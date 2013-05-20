object @general_refs

attributes :id, :direct_citation, :indirect_citation
node(:reference_text)  { |general_refs| sanitize(general_refs.reference_text, tags: []) }