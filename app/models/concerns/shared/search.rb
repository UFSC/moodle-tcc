module Shared::Search
  extend ActiveSupport::Concern

  included do
    def self.search(search, page, *options)

      options = options.extract_options!
      options[:eager_load] ||= []

      search_for(search).includes(options[:eager_load]).page(page).per(options[:per] ||= 30)
    end
  end

end