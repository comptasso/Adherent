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
    Adherent::Member.delete_all
    create_organism unless @organism
    n.times do |i|
      m = Adherent::Member.new(name:"Nom_#{i}", forname:'le prénom', number:"Adh00#{i}")
      m.organism_id = @organism.id
      puts m.errors.messages unless m.valid?
      m.save!
    end 
    @members = Adherent::Member.all
  end
  
  def create_payment(member, amount=50)
    member.payments.create!(amount:amount, date:Date.today,
    mode:'CB')
  end
end