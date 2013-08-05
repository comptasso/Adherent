require_dependency "adherent/application_controller"

module Adherent
  class CoordsController < ApplicationController
    
    before_filter :find_member, :except=>[:index]
    # GET /coords
    # GET /coords.json
    def index
      @coords = Coord.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @coords }
      end
    end
  
    # GET /coords/1
    # GET /coords/1.json
    def show
      @coord = @member.coord 
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @coord }
      end
    end
  
    # GET /coords/new
    # GET /coords/new.json
    def new
      @coord = @member.coords.new
  
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
      @coord = Coord.new(params[:coord])
  
      respond_to do |format|
        if @coord.save
          format.html { redirect_to @coord, notice: 'Coord was successfully created.' }
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
      @coord = Coord.find(params[:id])
  
      respond_to do |format|
        if @coord.update_attributes(params[:coord])
          format.html { redirect_to @coord, notice: 'Coord was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @coord.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /coords/1
    # DELETE /coords/1.json
    def destroy
      @coord = Coord.find(params[:id])
      @coord.destroy
  
      respond_to do |format|
        format.html { redirect_to coords_url }
        format.json { head :no_content }
      end
    end
    
    protected 
    
    def find_member
      @member = Member.find(params[:member_id])
    end
  end
end
