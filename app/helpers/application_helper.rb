# encoding: utf-8
module ApplicationHelper
  class MenuTabBuilder < TabsOnRails::Tabs::Builder
    def open_tabs(options = {})
      @context.tag('ul', {:class => 'nav nav-tabs'}, open = true)
    end

    def close_tabs(options = {})
      '</ul>'.html_safe
    end

    def tab_for(tab, name, options, item_options = {})
      item_options[:class] = (current_tab?(tab) ? 'active' : '')
      @context.content_tag(:li, item_options) { @context.link_to(name, options) }
    end
  end

  def required_fields
    '<p style="color:red">*Atributos Obrigatórios</p>'.html_safe
  end

  def display_icon(icon_name)
    content_tag('span', '', class: "glyphicon glyphicon-#{icon_name}", :'aria-header' => true)
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when 'success'
        'alert-success' # Green
      when 'error'
        'alert-danger' # Red
      when 'alert'
        'alert-warning' # Yellow
      when 'notice'
        'alert-info' # Blue
      else
        flash_type.to_s
    end
  end

  def moodle_user_meta_tag
    if @tcc
      tag('meta', :name => 'moodle-user', :content => @tcc.student.moodle_id)
    end
  end

  def reference_page_title(title)
    content_tag(:div, class: 'page-header') do
      content_tag(:h4, title)
    end
  end
end
