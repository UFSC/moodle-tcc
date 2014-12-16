class DatePickerJsInput < FormtasticBootstrap::Inputs::DatePickerInput

  def value
    return options[:input_html][:value] if options[:input_html] && options[:input_html].key?(:value)
    val = object.send(method)
    return I18n.l(Date.new(val.year, val.month, val.day)) if val.is_a?(Time)
    return val if val.nil?
    I18n.l(val)
  end

  def html_input_type
    'date_picker'
  end
end