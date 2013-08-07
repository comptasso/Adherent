# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class AdhesionsController < ApplicationController
    before_filter :find_member
    
    def index
      @adhesions = @member.adhesions
    end
  
    def edit
      @adhesion= @member.adhesions.find(params[:id])
    end
    
    # PUT /adhesions/1
    # PUT /adhesions/1.json
    def update
      @adhesion = Adhesion.find(params[:id])
  
      respond_to do |format|
        if @adhesion.update_attributes(params[:adhesion])
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
      @adhesion = @member.adhesions.new(params[:adhesion])
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
  
    def show
      
      @adhesion= @member.adhesions.find(params[:id])
      
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
  end
end
