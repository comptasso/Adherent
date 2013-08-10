# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class MembersController < ApplicationController
    # GET /members
    # GET /members.json
    def index
      @members = @organism.members.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @members }
      end
    end
  
    # GET /members/1
    # GET /members/1.json
    def show
      @member = Member.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @member }
      end
    end
  
    # GET /members/new
    # GET /members/new.json
    def new
      @member = @organism.members.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @member }
      end
    end
  
    # GET /members/1/edit
    def edit
      @member = Member.find(params[:id])
    end
  
    # POST /members
    # POST /members.json
    def create
      @member = @organism.members.new(params[:member])
  
      respond_to do |format|
        if @member.save
          format.html { redirect_to new_member_coord_url(@member.id), notice: 'Le membre a été créé avec succès ; Enregistrez maintenant les coordonnées' }
          format.json { render json: @member, status: :created, location: @member }
        else
          format.html { render action: "new" }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /members/1
    # PUT /members/1.json
    def update
      @member = Member.find(params[:id])
  
      respond_to do |format|
        if @member.update_attributes(params[:member])
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
      @member = Member.find(params[:id])
      @member.destroy
  
      respond_to do |format|
        format.html { redirect_to members_url }
        format.json { head :no_content }
      end
    end
  end
end
