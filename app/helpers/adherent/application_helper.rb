module Adherent
  module ApplicationHelper
    
    
    def icon_to(icon_file, options={}, html_options={})
    raise ArgumentError unless icon_file
    title = alt = icon_file.split('.')[0].capitalize

    html_options[:title] ||=title
    html_options[:class] ||= 'icon_menu'
    # html_options[:tabindex]= "-1"
    img_path="adherent/icones/#{icon_file}"
    link_to image_tag(img_path, :alt=> alt), options, html_options
  end
  end
end
