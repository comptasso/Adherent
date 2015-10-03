# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class CoordsController < ApplicationController
    
    before_filter :find_member, :except=>[:index] 
   
    # GET /coords/1
    # GET /coords/1.json
    def show
      @coord = @member.coord 
      unless @coord
        flash[:alert] = "Pas encore de coordonnées pour #{@member.to_s}"
        redirect_to new_member_coord_url(@member) and return
      end   
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @coord }
      end
    end
  
    # GET /coords/new
    # GET /coords/new.json
    def new
      @coord = @member.build_coord
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @coord }
      end
    end
  
    # GET /coords/1/edit
    def edit
      @coord = @member.coord
    end
  
    # POST /coords
    # POST /coords.json
    def create
      @coord = @member.build_coord(coord_params)
  
      respond_to do |format|
        if @coord.save
          format.html { redirect_to new_member_adhesion_url(@member), notice: 'Coordonnées enregistrées' }
          format.json { render json: @coord, status: :created, location: @coord }
        else
          format.html { render action: "new" }
          format.json { render json: @coord.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /coords/1
    # PUT /coords/1.json
    def update
      @coord = @member.coord
  
      respond_to do |format|
        if @coord.update_attributes(coord_params)
          format.html { redirect_to member_coord_path(@member), notice: 'Coordonnées mises à jour' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @coord.errors, status: :unprocessable_entity }
        end
      end
    end
  
    
    
    protected 
    
    def coord_params
      params.require(:coord).permit(:address, :city, :gsm, :mail, :office, :references, :tel, :zip)
    end
  end
end
