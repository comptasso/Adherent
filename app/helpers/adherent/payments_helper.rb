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
      rs = payment.reglements.includes(:adhesion=>:member).to_a
      if rs.size == 1 && rs.first.adhesion.member == member
        adh = rs.first.adhesion
        "votre adhésion pour la période #{du_au(adh.from_date, adh.to_date)}"
        
      elsif rs.size == 1
        # une seule adhésion mais pas pour lui
        adh = rs.first.adhesion
        m = adh.member
        "l'adhésion de #{m.forname} #{m.name} pour la période #{du_au(adh.from_date, adh.to_date)}"    
      else  
        # plusieurs adhésions
        str  = "les adhésions de <ul>"
        rs.each do |r| 
          str+='<li>'
          adh = r.adhesion
          m = adh.member
          str += "#{m.forname} #{m.name} pour la période #{du_au(adh.from_date, adh.to_date)}"
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
  end
end
