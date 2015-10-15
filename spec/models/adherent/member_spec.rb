# coding utf-8

require 'rails_helper'

describe Adherent::Member, :type => :model do
  fixtures :all
  
  def valid_attributes
    {name:'Dupont', forname:'Jules', number:'Adh 001', organism_id:1}
  end
  
  describe 'validation' do
    it 'valid_attributes est valide' do
      m = Adherent::Member.new(valid_attributes)
      expect(m).to be_valid
    end
    
    it 'invalide sans nom' do
      m = adherent_members(:Dupont)
      m.name = nil
      expect(m).not_to be_valid
    end
    
    it 'invalide sans prenom' do
      m = adherent_members(:Dupont)
      m.forname = nil
      expect(m).not_to be_valid
    end
    
    it 'invalide sans numéro' do
      m = adherent_members(:Dupont)
      m.number = nil
      expect(m).not_to be_valid
    end
    
    it 'invalide si numero existe déja pour cet organisme' do
      m = Adherent::Member.new(name:'Dupont', forname:'Alain', organism_id:1, 
        number:adherent_members(:Dupont).number)
      expect(m).not_to be_valid
    end
    
    it 'mais valide pour un autre organisme' do
      m = Adherent::Member.new(name:'Dupont', forname:'Alain', organism_id:2, 
        number:adherent_members(:Dupont).number)
      expect(m).to be_valid
    end
    
    describe 'test de birthdate' do
      it 'on peut rentrer une date de naissance' do
        m = adherent_members(:Durand)
        m.birthdate = '06/06/1944'
        m.save
        expect(m.read_attribute(:birthdate)).to eq(Date.civil(1944,6,6))
      end
      
    end
      
  end 
  
  describe 'méthodes' do
       
    it 'to s renvoie le nom et le prénom' do
      expect(adherent_members(:Dupont).to_s).to eq('Jules DUPONT')
    end
    
    describe 'next_adhesion' do
      context 'un membre qui n en a pas encore' do
        
        subject {adherent_members(:Durand)}
      
        it 'next_adhesion renvoie une adhésion relevant de ce membre' do
          expect(subject.next_adhesion).to be_an_instance_of(Adherent::Adhesion)
        end
      
        it 'avec 0 comme montant' do
          expect(subject.next_adhesion.amount).to eq(0)
        end
      
        it 'mais on peut fournir un montant' do
          @na = subject.next_adhesion(25)
          expect(@na.amount).to eq(25)
        end
      
      end
      
      context 'un membre avec déjà une adhésion' do
        
        subject {adherent_members(:Dupont)}
        
        it 'next_adhesion renvoie une adhésion' do
          expect(subject.next_adhesion).to be_an_instance_of(Adherent::Adhesion)
        end
        
        it 'dont le montant est identique au précédent'do
          expect(subject.next_adhesion.amount).to eq(26.66)
        end
        
        it 'mais on peut surcharger' do
          expect(subject.next_adhesion(44).amount).to eq(44)
        end
        
      end
    
    end
    
    describe 'les adhésions impayées' do
      
      subject {adherent_members(:Dupont)}
      
      it 'le membre a des adhésions non payées' do
        expect(subject).to be_unpaid_adhesions
      end
          
      it 'pour un montant total de 26,66 -15' do
        expect(subject.unpaid_amount).to eq(11.66)
      end
      
    end
    
    describe 'jusquau' do
      
      context 'sans adhésion' do
        
        subject {adherent_members(:Durand)}
        
        it 'renvoie inconnu' do
          expect(subject.jusquau).to eq(I18n::l subject.created_at.to_date)
        end
        
      end
      
      context 'avec adhésion' do
        subject {adherent_members(:Dupont)}
        
        it 'renvoie la date de fin cette adhésion' do
          expect(subject.jusquau).to eq I18n::l(Date.today.years_since(1) -1)
        end
        
      end
      
    end
    
    describe 'query_members' do
      subject {adherent_members(:Fidele)}
        
      before(:each) do
        subject.build_coord(tel:'01.02.03.04.05', mail:'bonjour@example.com') 
        subject.save!
      end
        
      it 'query_member' do
        expect(Adherent::Member.query_members(organisms(:asso)).size).to eq(3) 
      end 
      
      it 'peut créer un csv' do
        expect {Adherent::Member.to_csv(organisms(:asso))}.to_not raise_error
      end
      
      it 'qui possède une ligne de titre' do
        csv  = Adherent::Member.to_csv(organisms(:asso))
        expect(csv.split("\n").first).
          to eq  "Numero\tNom\tPrénom\tDate de naissance\tMail\tTél\tGsm\tBureau\tAdresse\tCode Postal\tVille\tDoit\tFin Adh."
      end
      
      it 'qui possède une ligne des lignes adhérents' do
        csv  = Adherent::Member.to_csv(organisms(:asso))
        fidele = csv.split("\n").select {|l| 'Fidele'.in? l}.first
        expect(fidele). 
          to eq "A003\tFidele\tChe\t\tbonjour@example.com\t01.02.03.04.05\t\t\t\t\t\t45,00\t#{I18n::l(Date.today.years_since(2) -1)}"
      end
   
      context 'avec deux adhésions' do
        
        subject {adherent_members(:Fidele)}
      
        it 'donne la bonne fin d adhésion' do
          expect(subject.jusquau).to eq I18n::l((Date.today.years_since(2)) -1)
        end
     
        context 'avec des règlements'  do
          # Fidele est un membre avec deux adhésions de 25 € chacune
       
          before(:each) do
            @p = subject.payments.new(date:Date.today, amount:8, mode:'CB')
            allow(@p).to receive(:correct_range_date).and_return true 
            @p.save
           end
      
          it 'le membre doit encore 14.26 ' do
            ms = Adherent::Member.query_members(organisms(:asso))
            m = ms.select {|a| a.number == subject.number}.first 
            expect(m.t_reglements).to eq(13)
            expect(m.t_adhesions).to eq(50)
            expect(m.montant_du).to eq(37) 
          end
      
          it 'après un paiement de 10.50 €, il doit encore 31,50' do
            @p = subject.payments.new(date:Date.today, amount:10.50, mode:'CB')
            allow(@p).to receive(:correct_range_date).and_return true 
            @p.save
            ms = Adherent::Member.query_members(organisms(:asso))
            m = ms.select {|a| a.number == subject.number}.first 
            expect(m.montant_du).to eq(26.50) 
            expect(m.a_jour?).to be false
          end
      
          it 'avec de paiements, l un de 20,50, l autre de 21,50 € il ne doit plus rien' do
            @p = subject.payments.new(date:Date.today, amount:20.50, mode:'CB')
            @q = subject.payments.new(date:Date.today, amount:21.50, mode:'CB')
            allow(@p).to receive(:correct_range_date).and_return true 
            allow(@q).to receive(:correct_range_date).and_return true 
            @p.save; @q.save
            ms = Adherent::Member.query_members(organisms(:asso))
            m = ms.select {|a| a.number == subject.number}.first 
            expect(m.montant_du).to eq(0) 
            expect(m.a_jour?).to be true
          end
      
          it 's il paye plus il ne doit rien non plus' do
            @p = subject.payments.new(date:Date.today, amount:60, mode:'CB')
            allow(@p).to receive(:correct_range_date).and_return true 
            @p.save
            ms = Adherent::Member.query_members(organisms(:asso))
            m = ms.select {|a| a.number == subject.number}.first 
            expect(m.montant_du).to eq(0) 
            expect(m.a_jour?).to be true
          end
      
        end
      end
    end
  end
end


