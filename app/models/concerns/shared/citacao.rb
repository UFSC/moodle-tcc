module Shared::Citacao
  extend ActiveSupport::Concern

  included do
    def indirect_citation
      if respond_to?('et_all')
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

    def direct_citation
      if respond_to?('et_all')
        return direct_et_al if et_all
      end
      citation = ''
      get_all_authors.each do |author|
        unless author.nil? || author.blank?
          citation = citation +' ' + UnicodeUtils.upcase(author.split(' ').last)+';'
        end
      end
      "(#{citation.strip.chop!}, #{year})"

    end

    def direct_et_al
      "(#{UnicodeUtils.upcase(first_author.split(' ').last)} et al., #{year})"
    end

    def check_for_usage
      return if self.reference.nil?
      tcc = self.reference.tcc

      return false if has_citation(tcc.abstract)
      tcc.chapters.each do |chapter|
        return false if has_citation(chapter)
      end
    end
  end

  def is_citation_free_to_destroy?(text)
    doc = Nokogiri::HTML(text)

    doc.search('citacao').each do |node|
      if (node['reference_id'].to_i.equal?(self.reference.id))
        errors[:base] << 'Esta referência está sendo usada em algum texto. Não é possível deletá-la.'
        return false
      end
    end

    true
  end

  def has_citation(object)
    object.blank? ? false : !is_citation_free_to_destroy?(object.content)
  end

end