
# pour avoir les méthodes d'authenfication proposées par l'ApplicationController
# ainsi que la gestion des sessions et notamment la méthode find_organism
class Adherent::ApplicationController < ApplicationController
  
  # met en forme une date au format dd-mmm-yyyy en retirant le point 
  # par exemple 13-nov-2013 (et non 13-nov.-2016), ceci pour pouvoir 
  # facilement inclure la date dans le nom d'un fichier
  def dashed_date(date)
    I18n.l(date, format:'%d-%b-%Y').gsub('.', '')
  end

end

