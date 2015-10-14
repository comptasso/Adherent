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
    
    def icon_to_if(condition, icon_file, options={}, html_options={})
      raise ArgumentError unless icon_file
      title = alt = icon_file.split('.')[0].capitalize

      html_options[:title] ||=title
      html_options[:class] ||= 'icon_menu'
      # html_options[:tabindex]= "-1"
      img_path="adherent/icones/#{icon_file}"
      link_to_if condition, image_tag(img_path, :alt=> alt), options, html_options
    end
    
    # Pour transformer un montant selon le format numérique français avec deux décimales
    def virgule(montant)
      ActionController::Base.helpers.number_with_precision(montant, precision:2) rescue '0,00'
    end
    
    def two_decimals(montant)
      sprintf('%0.02f',montant) rescue  '0.00'
    end
    
        
    def icon_to_users
      icon_to 'users.png', members_path, title:'Liste des membres' 
    end
    
    def list_imputations(payment)
      content_tag(:ul) do
        payment.reglements.map do |r|
          content_tag(:li) do
            imputation_with_actions(payment, r)
          end
        end.join.html_safe
      end
    end
    
    def imputation_with_actions(pay, r)
      # on gère le cas où l'adhésion a disparu (car le membre a disparu)
      a = r.adhesion
      mem = a ? a.member : 'supprimée'
      html = ''
      html << "Adhésion #{mem} pour #{number_to_currency(r.amount, locale: :fr)}"
      html << "&nbsp;&nbsp;"
      html << "#{icon_to 'detail.png', payment_reglement_path(pay.id, r.id)}"
      html.html_safe
    end
    
    def non_impute(payment)
      payment.amount - payment.reglements.to_a.sum(&:amount)
    end
    
  end
end
