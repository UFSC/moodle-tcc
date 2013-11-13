object @article_ref

attributes :id, :article_subtitle,:article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name, :local, :number_or_fascicle, :year, :second_author, :third_author, :volume_number
node(:display_message) { |article_refs| article_refs.article_title }
node(:direct_citation) { |article_refs| article_refs.direct_citation }
node(:indirect_citation) { |article_refs| article_refs.indirect_citation }
node(:reference_id) { |article_refs| article_refs.reference.id }