class RaceTeamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin, :only => [:index,:destroy]
  # GET /race_teams
  # GET /race_teams.json
  def index
    @race_teams = RaceTeam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @race_teams }
    end
  end

  # GET /race_teams/1
  # GET /race_teams/1.json
  def show
    @race_team = RaceTeam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @race_team }
    end
  end

  # GET /race_teams/new
  # GET /race_teams/new.json
  def new
    @race_team = RaceTeam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @race_team }
    end
  end

  # GET /race_teams/1/edit
  def edit
    @race_team = RaceTeam.find(params[:id])
  end

  # POST /race_teams
  # POST /race_teams.json
  def create
    @race_team = RaceTeam.new(params[:race_team])

    respond_to do |format|
      if @race_team.save
        format.html { redirect_to @race_team, notice: 'Race team was successfully created.' }
        format.json { render json: @race_team, status: :created, location: @race_team }
      else
        format.html { render action: "new" }
        format.json { render json: @race_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /race_teams/1
  # PUT /race_teams/1.json
  def update
    @race_team = RaceTeam.find(params[:id])

    respond_to do |format|
      if @race_team.update_attributes(params[:race_team])
        format.html { redirect_to @race_team, notice: 'Race team was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @race_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /race_teams/1
  # DELETE /race_teams/1.json
  def destroy
    @race_team = RaceTeam.find(params[:id])
    @race_team.destroy

    respond_to do |format|
      format.html { redirect_to race_teams_url }
      format.json { head :ok }
    end
  end
end
