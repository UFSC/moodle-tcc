module Shared::Citacao
  extend ActiveSupport::Concern

  included do
    def indirect_citation
      if respond_to? 'et_all'
        return indirect_et_al if et_all
      end

      elements = Array.new
      get_all_authors.each do |author|
        unless author.nil? || author.blank?
          elements << UnicodeUtils.titlecase(author.split(' ').last)
        end
      end
      "#{elements.to_sentence} (#{year})"
    end

    def indirect_et_al
      "#{UnicodeUtils.titlecase(first_author.split(' ').last)} et al. (#{year})"
    end
  end

end