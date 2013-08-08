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
    
    # Pour transformer un montant selon le format numérique français avec deux décimales
    def virgule(montant)
      ActionController::Base.helpers.number_with_precision(montant, precision:2) rescue '0,00'
    end
  end
end
