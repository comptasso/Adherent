# coding utf-8

require 'rails_helper'
require 'support/fixtures'

RSpec.configure do |c|
 #   c.filter = {wip:true}
end

describe 'REGLEMENT', :type => :feature do 
  include Fixtures 
  
  def create_payment(montant)
    visit adherent.new_member_payment_path(@member)
    fill_in 'Date', with:I18n.l(Date.today)
    fill_in 'Montant', with:montant
    select 'CB'
    click_button 'Enregistrer'
  end
  
  
  before(:each) do
    create_members(3)
    @member= @members.first
    @member.next_adhesion(50).save!
  end
   
  describe 'un membre avec une adhésion effectue un paiement du montant exact' do
     
    it 'créer le payment change le nombre de payments' do
      expect {create_payment(50)}.to change {@member.payments.count}.by(1)
    end
    
    it 'créer le payment crée un règlement' do
      expect {create_payment(50)}.to change {Adherent::Reglement.count}.by(1)
    end
    
    it 'l adhesion du membre est réglée' do
      create_payment(50)
      expect(@member.unpaid_adhesions?).to be false
    end
    
  end
  
  describe 'le membre effectue un payment d un montant supérieur' do
    
    before(:each) do
      create_payment(66)
    end
    
    it 'l adhésion du membre est réglée' do
      expect(@member.unpaid_adhesions?).to be false
    end
    
    it 'il reste un montant à imputer' do
      expect(@member.payments.last.non_impute).to eq(16) 
    end
    
  end
  
   describe 'le membre effectue un payment d un montant inférieur' do
    
    before(:each) do
      create_payment(33)
    end
    
    it 'l adhésion du membre est réglée' do
      expect(@member.unpaid_adhesions?).to eq(true)
    end
    
    it 'il reste un montant à imputer' do
      expect(@member.unpaid_amount).to eq(17)
    end
    
  end
  
  describe 'imputation sur d autres adhésions' do
    
   
    before(:each) do
      create_payment(80)
      @pay = @member.payments.last
      @member2 = @members.second
      @member2.next_adhesion(49).save
      @members.third.next_adhesion(27).save
      visit adherent.new_payment_reglement_path(@pay)
    end
   
    # on a donc un payment de 80 qui va être imputé sur l'adhésion et qui pourra 
    # l'être pour les 30 restants sur les deux autres
    it 'on vérifie' do
      expect(@member.unpaid_amount).to eq(0)
      expect(@member.payments.last.non_impute).to eq(30)
    end
    
    it 'la page new_reglement affiche un form' do
      expect(page.all('form').size).to eq(1)
    end
    
    it 'le montant affiché est le montant restant' do
      expect(page.find('#reglement_amount').value).to eq('30,00 €')
    end
    
    it 'le select propose les deux adhesions' do
      expect(page.all('#reglement_adhesion_id option').size).to eq(3) # avec le prompt
    end
    
    describe 'on choisit une option et on valide' do
      
      before(:each) do
        select "#{@member2.to_s} - 49,00 €", :from=>'Adhésion'
        click_button 'Enregistrer' 
      end
      
      it 'on revient à la page index des payements' do
        expect(page.find('h3').text).to eq("Historique des paiements reçus de #{@member.to_s}")
      end
      
      it 'il y a maintenant 2 reglements' do
        regs = Adherent::Reglement.all
        expect(regs.size).to eq(2)        
      end
      
      it 'le premier appartenant à member et pour 50 €' do
        arf = Adherent::Reglement.first
        expect(arf.payment_id).to eq(@pay.id)
        expect(arf.adhesion.member).to eq(@member)
        expect(arf.amount).to eq(50)
      end
      
      it 'le deuxième règlement' do
        arl = Adherent::Reglement.last
        expect(arl.payment_id).to eq(@pay.id)
        expect(arl.adhesion.member).to eq(@member2)
        expect(arl.amount).to eq(30)
      end
      
      it 'le membre2 ne doit plus que 19 €' do
        expect(@member2.unpaid_amount).to eq(19)
      end
      
      
    end
    
    
  end
   
end
