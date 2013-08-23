# coding utf-8

# ce module a pour objet de fournir quelques méthodes pour créer des 
# enregistrements utilisés dans les requests
module Fixtures
  
  def create_organism
    @organism =  Organism.find_or_create_by_title('Mon association')
  end
  
  # crée des membres, 5 étant le nombre par défaut. Il est possible d'avoir un
  # nombre différent en fournissant en argument un nombre quelconque.
  def create_members(n = 5)
    create_organism unless @organism
    n.times do |i|
      m = Adherent::Member.new(name:"Nom_#{i}", forname:'le prénom', number:"Adh00#{i}")
      m.organism_id = @organism.id
      m.save!
    end    
  end
end