require_dependency "adherent/application_controller"

module Adherent
  class AdherentsController < ApplicationController
    # GET /adherents
    # GET /adherents.json
    def index
      @adherents = Adherent.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @adherents }
      end
    end
  
    # GET /adherents/1
    # GET /adherents/1.json
    def show
      @adherent = Adherent.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @adherent }
      end
    end
  
    # GET /adherents/new
    # GET /adherents/new.json
    def new
      @adherent = Adherent.new
      @date_min = Date.civil(1900,1,1)
      @date_max = Date.civil(2020,12,31)
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @adherent }
      end
    end
  
    # GET /adherents/1/edit
    def edit
      @adherent = Adherent.find(params[:id])
      @date_min = Date.civil(1900,1,1)
      @date_max = Date.civil(2020,12,31)
    end
  
    # POST /adherents
    # POST /adherents.json
    def create
      @adherent = Adherent.new(params[:adherent])
  
      respond_to do |format|
        if @adherent.save
          format.html { redirect_to @adherent, notice: 'Adherent was successfully created.' }
          format.json { render json: @adherent, status: :created, location: @adherent }
        else
          format.html { render action: "new" }
          format.json { render json: @adherent.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /adherents/1
    # PUT /adherents/1.json
    def update
      @adherent = Adherent.find(params[:id])
  
      respond_to do |format|
        if @adherent.update_attributes(params[:adherent])
          format.html { redirect_to @adherent, notice: 'Adherent was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @adherent.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /adherents/1
    # DELETE /adherents/1.json
    def destroy
      @adherent = Adherent.find(params[:id])
      @adherent.destroy
  
      respond_to do |format|
        format.html { redirect_to adherents_url }
        format.json { head :no_content }
      end
    end
  end
end
