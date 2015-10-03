# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class MembersController < ApplicationController
    # GET /members
    # GET /members.json
    def index 
      
      @members = Adherent::QueryMember.query_members(@organism)
  
      respond_to do |format|
        format.html # index.html.erb
        format.csv { send_data Adherent::QueryMember.to_csv(@organism),
          :filename=>"#{@organism.title}-#{dashed_date(Date.today)}-Membres.csv"  } 
        
        format.xls { send_data Adherent::QueryMember.to_xls(@organism),
          :filename=>"#{@organism.title}-#{dashed_date(Date.today)}-Membres.csv"  }
        format.json { render json:@members }
      end
    end
  
    # GET /members/1
    # GET /members/1.json
    def show
      @member = @organism.members.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json:@member }
      end
    end
  
    # GET /members/new
    # GET /members/new.json
    def new
      @member = @organism.members.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json:@member }
      end
    end
  
    # GET /members/1/edit
    def edit
      @member = @organism.members.find(params[:id])
    end
  
    # POST /members
    # POST /members.json
    def create
      @member = @organism.members.new(member_params)
  
      respond_to do |format|
        if @member.save
          format.html { redirect_to new_member_coord_url(@member.id), notice: 'Le membre a été créé ; Enregistrez maintenant les coordonnées' }
          format.json { render json: @member, status: :created, location: @member }
        else
          format.html { render action: "new" }
          format.json { render json:@member.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /members/1
    # PUT /members/1.json
    def update
      @member = @organism.members.find(params[:id])
  
      respond_to do |format|
        if @member.update_attributes(member_params)
          format.html { redirect_to @member, notice: 'Les données ont été mises à jour' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /members/1
    # DELETE /members/1.json
    def destroy
      @member = @organism.members.find(params[:id])
      @member.destroy
  
      respond_to do |format|
        format.html { redirect_to members_url }
        format.json { head :no_content }
      end
    end
    
    private 
    
     # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:birthdate, :forname, :name, :number)
    end
  end
end
