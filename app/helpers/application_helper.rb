# encoding: utf-8
module ApplicationHelper
  class MenuTabBuilder < TabsOnRails::Tabs::Builder
    def open_tabs(options = {})
      @context.tag("ul", {:class => 'nav nav-tabs' }, open = true)
    end
    #
    def close_tabs(options = {})
      "</ul>".html_safe
    end

    def tab_for(tab, name, options, item_options = {})
      item_options[:class] = (current_tab?(tab) ? 'active' : '')
      @context.content_tag(:li, item_options) do
        @context.link_to(name, options)
      end
    end
  end

  def required_fields
    "<p style='color:red'>*Atributos Obrigatórios</p>".html_safe
  end
end
