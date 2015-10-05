# coding utf-8

require 'rails_helper'

RSpec.configure do |c|
  # c.exclusion_filter = {js:true}
  # c.filter = {wip:true}
end


describe Adherent::QueryMember, :type => :model do 
  
  def valid_attributes
    {name:'Dupont', forname:'Jules', number:'Adh 001',
      birthdate:Date.civil(1955,6,6)}
  end
  
  let(:org) {double(Organism, id:1)}
  
  before(:each) do
    @m = Adherent::Member.new(valid_attributes) 
    @m.organism_id = 1
    @m.save!
    @m.build_coord(tel:'01.02.03.04.05', mail:'bonjour@example.com') 
    @m.save
  end
  
  after(:each) do
    Adherent::Member.delete_all
    Adherent::Coord.delete_all
  end
  
  it 'on peut initier un query_member' do
    expect(Adherent::QueryMember.query_members(org).size).to eq(1) 
  end
  
  it 'dont les champs sont corrects' do
    m = Adherent::QueryMember.query_members(org).first
    expect(m.birthdate).to eq('06/06/1955')
    expect(m.name).to eq(@m.name)
    expect(m.forname).to eq(@m.forname)
    expect(m.tel).to eq(@m.coord.tel)
    expect(m.mail).to eq(@m.coord.mail)
    
  end
  
  context 'avec deux adhésions' do
    
    before(:each) do
      d = Date.today.beginning_of_year
      @m.adhesions.new(from_date:d, to_date:(d>>1) -1, amount:12.25)
      @m.adhesions.new(from_date:(d>>1), to_date:(d>>2)-1, amount:10.01)
      @m.save
       
    end
     
    it 'donne la bonne fin d adhésion' do
      m = Adherent::QueryMember.query_members(org).first
      expect(m.m_to_date).to eq(I18n::l((Date.today.beginning_of_year>>2) -1)) 
    end
     
    context 'avec des règlements' do
       
      before(:each) do
        @p = @m.payments.new(date:Date.today, amount:8, mode:'CB')
        allow(@p).to receive(:correct_range_date).and_return true 
        @p.save
       
        
      end
     
      after(:each) do 
        Adherent::Reglement.delete_all
        Adherent::Adhesion.delete_all
        Adherent::Payment.delete_all
        
      end
      
      it 'le membre doit encore 14.26 ' do
        m = Adherent::QueryMember.query_members(org).first
        expect(m.t_reglements).to eq(8)
        expect(m.t_adhesions).to eq(22.26)
        expect(m.montant_du).to eq(14.26) 
      end
      
      it 'après un paiement de 10.26 €, il doit encore 4' do
        @p = @m.payments.new(date:Date.today, amount:10.26, mode:'CB')
        allow(@p).to receive(:correct_range_date).and_return true 
        @p.save
        m = Adherent::QueryMember.query_members(org).first
        expect(m.montant_du).to eq(4) 
        expect(m.a_jour?).to be false
      end
      
      it 'avec de paiements, l un de 10, l autre de 14.26 € il ne doit plus rien' do
        @p = @m.payments.new(date:Date.today, amount:10, mode:'CB')
        @q = @m.payments.new(date:Date.today, amount:14.26, mode:'CB')
        allow(@p).to receive(:correct_range_date).and_return true 
        allow(@q).to receive(:correct_range_date).and_return true 
        @p.save; @q.save
        m = Adherent::QueryMember.query_members(org).first
        expect(m.montant_du).to eq(0) 
        expect(m.a_jour?).to be true
      end
      
      it 's il paye plus il ne doit rien non plus' do
        @p = @m.payments.new(date:Date.today, amount:25, mode:'CB')
       
        allow(@p).to receive(:correct_range_date).and_return true 
      
        @p.save
        m = Adherent::QueryMember.query_members(org).first
        expect(m.montant_du).to eq(0) 
        expect(m.a_jour?).to be true
      end
      
      
    end
     
     
    describe 'export' do
      
      def two_lines
        [Adherent::QueryMember.new(number:'Adh 001', name:'Dupont', forname:'Jules',
            birthdate:Date.civil(1955,6,6), mail:'bonjour@example.com', 
            tel:'01.02.03.04.05', t_adhesions:22.26, t_reglements:0,
            office:'03.20.14.64.30',
            zip:'59000',
            address:'Place de la Mairie',
            city:'LILLE',
            m_to_date:((Date.today.beginning_of_year >> 2) -1))
        ]
      end  
    
  
      describe 'to_csv' do
    
        before(:each) do
          @organism =  double(Organism, id:1)
          allow(Adherent::QueryMember).to receive(:query_members).with(@organism).
            and_return(two_lines)
          csv = Adherent::QueryMember.to_csv(@organism)
          @lignes = csv.split("\n")
        end
        it 'la ligne de titre' do
          expect(@lignes[0]).to eq("Numero\tNom\tPrénom\tDate de naissance\tMail\tTél\tGsm\tBureau\tAdresse\tCode Postal\tVille\tDoit\tFin Adh.")
        end
      
        it 'une ligne de valeurs' do
          expect(@lignes[1]).to eq("Adh 001\tDupont\tJules\t06/06/1955\tbonjour@example.com\t01.02.03.04.05\t\t03.20.14.64.30\tPlace de la Mairie\t59000\tLILLE\t22,26\t#{I18n::l((Date.today.beginning_of_year>>2) -1)}")
        end
       
      end
    
      describe 'to_xls' do
        before(:each) do
          @organism =  double(Organism, id:1)
          allow(Adherent::QueryMember).to receive(:query_members).with(@organism).
            and_return(two_lines)
        end
      
        it 'to_xls doit marcher également' do
          expect {Adherent::QueryMember.to_xls(@organism)}.not_to raise_error
        end
      end
    end
  end
  
end