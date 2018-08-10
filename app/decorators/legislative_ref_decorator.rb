class LegislativeRefDecorator < GenericReferenceDecorator
  delegate_all

  def direct_citation
    "(#{UnicodeUtils.upcase(jurisdiction_or_header)}, #{year})"
  end

  def indirect_citation
    "#{UnicodeUtils.titlecase(jurisdiction_or_header)} (#{year})"
  end
end