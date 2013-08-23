# coding: utf-8

# Ce module étend la classe dans laquelle il est inclus
# pour avoir des arguments virtuels de type pick_date
# La déclaration se fait en appelant pick_date_for avec une liste d'arguments
# du modèle de type date.
# Exemple pick_date_for :begin_date, :end_date
#
# Ce qui définit quatre méthodes
# begin_date_picker et begin_date_picker=
# ainsi que end_date et end_date_picker=
#
# Chacune de ces méthodes servent alors d'attribut virtuel pour transformer les dates
# au format ruby en string au format jj/mm/aaaa
#
# Dans les vues, l'utilisation de ces facilités suppose simple_form_for et
# son extension app/inputs/date_picker_input
#
module PickDateExtension
    
  extend ActiveSupport::Concern
 
  included do
  end

  module ClassMethods
    # définition de la méthode de classe pick_date_for
    # laquelle définit une série de méthode getter et setter
    def  pick_date_for(*args)

      
      args.each do |arg|
        # definition de arg_picker
        send :define_method, "#{arg.to_s}" do 
          value = self.send(:read_attribute, arg)
          return value.is_a?(Date) ? (I18n::l value) : value
        end

        # definition de arg_picker=
        # arg_picker= peut accepter comme argument soit une date, 
        # soit une chaîne au format dd/mm/yyyyy. 
        # Si la chaîne est vide, la date sera nil
        #
        # La méthode retourne soit nil si une date n'a pu être calculée, soit 
        # la valeur qui a servi d'argument
        send :define_method, "#{arg.to_s}=" do |value|
          date = case value
          when Date then value
          when '' then nil
          else
            s  = value.split('/') if value
            date = Date.civil(*s.reverse.map{|e| e.to_i}) rescue nil
          end
          
          self.send(:write_attribute, arg, date)
          (date && date > Date.civil(1900,1,1)) ? value : nil
                      
        end

      
      end

    
    end
  end

end
  
  
ActiveRecord::Base.send :include, PickDateExtension

