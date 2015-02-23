# la classe FenchDecimalInput permet d'utiliser les
# possibilités de html 5 (text pattern) mais pas numeric car Chrome
# rentre les points décimaux d'un clavier comme des points
# ce qui n'est pas accepté et tronque les décimales.
#
class FrenchDecimalInput < SimpleForm::Inputs::Base

 def input(wrapper_options)
   input_html_options['type'] = 'text' # probablement inutile
   input_html_options['pattern'] = '\-?\d+(\.\d{0,2})?'
   input_html_classes.unshift('numeric decimal form-control')
   @builder.text_field(attribute_name, input_html_options)
  end
end

