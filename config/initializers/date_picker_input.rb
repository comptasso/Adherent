# TODO mettre cet input dans l'espace de nom Adherent.

require 'simple_form'
# la classe DatePickerInput permet d'avoir un champ de saisie de date avec
# un widget qui permet de sélectionner la date.
# Le widget vient de jQueryUI et réagit aux champs ayant la classe input_date_picker
# Un fichier css permet d'afficher un petit calendrier dans le champ de saisie.
# Les champs data-min et date-max sont à fournir et servent de limite au widget
# La méthode input transforme ces valeurs en un format lisible par javascript.
#

# ajout d'un format de date personnalisé
Date::DATE_FORMATS[:date_picker] = "%d/%m/%Y"

class DatePickerInput < SimpleForm::Inputs::Base

 def input
   input_html_options['data-jcmin'] = date_min(input_html_options[:date_min])
   input_html_options['data-jcmax'] = date_max(input_html_options[:date_max])
   input_html_classes.unshift('input_date_picker form-control')
   
   input_html_options.delete :date_min
   input_html_options.delete :date_max

    @builder.text_field(attribute_name, input_html_options)
  end
  
 protected
 
  def date_min(option)
    
    option ||= Date.today.years_ago(5)
    option.to_formatted_s(:date_picker)
  end
  
  def date_max(option)
    option ||= Date.today.years_since(5)
    option.to_formatted_s(:date_picker)
  end
end


