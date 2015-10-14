module Adherent
  module PaymentsHelper
    def min_date 
      @member.organism.range_date.first
    end
    
    def max_date
      @member.organism.range_date.last
    end
    
    # cas de figure : le payment correspond précisément à l'adhésion du membre
    # on fait une édition simple : pour votre cotisation du .... au ...
    # Le payment reprend plusieurs règlements 
    # TODO A voir, il peut y avoir des paiements partiels ou total
    def recu_cotisation(payment, member)
      rs = payment.reglements
      if rs.count == 1 && rs.first.try(:adhesion).try(:member) == member
        adh = rs.first.adhesion
        "Adhésion pour la période #{du_au(adh.from_date, adh.to_date)}"
        
      elsif rs.size == 1
        # une seule adhésion mais pas pour lui
        adh = rs.first.adhesion
        "l'adhésion de #{coords(adh)} pour la période #{pour(adh)}"    
      else  
        # plusieurs adhésions
        str  = "les adhésions de <ul>"
        rs.each do |r| 
          str+='<li>'
          adh = r.adhesion
          
          str += "#{coords(adh)} pour la période #{pour(adh)}"
          str += '</li>'
        end
        str += '</ul>'
        str.html_safe
      end
      
    end
    
    protected 
    
    def du_au(from_date, to_date)
      "du #{from_date} au #{to_date}"
    end
    
    def coords(adh)
      if adh && m = adh.member
        "#{m.name} #{m.forname}"
      else
        'Effacé'
      end
    end
    
    def pour(adh)
      if adh
      "#{du_au(adh.from_date, adh.to_date)}"
      else
       'du ??? au ???' 
      end
    end
  end
end
