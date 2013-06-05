object @internet_refs

attributes :id, :access_date, :author, :subtitle, :title, :url
node(:display_message) { |internet_refs| internet_refs.title}