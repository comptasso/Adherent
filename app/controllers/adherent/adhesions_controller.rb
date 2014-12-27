# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class AdhesionsController < ApplicationController
    before_filter :find_member
    
    def index
      @adhesions = @member.adhesions
      if @adhesions.empty?
        flash[:notice] = 'Pas encore d\'adhésion pour ce membre ; redirigé vers la création d\'une adhésion'
        redirect_to new_member_adhesion_url(@member)
      end
    end
  
    def edit
      @adhesion= @member.adhesions.find(params[:id])
    end
    
    # PUT /adhesions/1
    # PUT /adhesions/1.json
    def update
      @adhesion = @member.adhesions.find(params[:id])
  
      respond_to do |format|
        if @adhesion.update_attributes(adhesion_params)
          format.html { redirect_to member_adhesions_path(@member), notice: 'Adhésion mise à jour.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          
        end
      end
    end
  
    def new
      @adhesion = @member.next_adhesion
    end
    
    # POST /adhesions
    # POST /adhesions.json
    def create
      @adhesion = @member.adhesions.new(adhesion_params)
      unless @adhesion.valid?
        
        flash[:notice] = @adhesion.errors.messages
      end
      respond_to do |format|
        if @adhesion.save
          format.html { redirect_to member_adhesions_url(@member), notice: 'Adhésion créée' }
          format.json { render json: @adhesion, status: :created, location: @adhesion }
        else
          format.html { render action: "new" }
          format.json { render json: @adhesion.errors, status: :unprocessable_entity }
        end
      end
    end
  
  
    
    # DELETE /adhesion/1
    # DELETE /coords/1.json
    def destroy
      @adhesion = @member.adhesions.find(params[:id])
      @adhesion.destroy
  
      respond_to do |format|
        format.html { redirect_to member_adhesions_url(@member) }
        
      end
    end
    
    protected
    
    def find_member
      @member = Member.find(params[:member_id])
    end
    
    private 
    
     # Never trust parameters from the scary internet, only allow the white list through.
    def adhesion_params
      params.require(:adhesion).permit(:from_date, :to_date, :amount)
    end
  end
end
