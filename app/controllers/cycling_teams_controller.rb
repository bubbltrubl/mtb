class CyclingTeamsController < ApplicationController
  def index
    @cycling_teams = CyclingTeam.all
  end

  def show
    @cycling_team = CyclingTeam.find(params[:id])
  end

  def new
    @cycling_team = CyclingTeam.new
  end

  def create
    @cycling_team = CyclingTeam.new(params[:cycling_team])
    if @cycling_team.save
      redirect_to @cycling_team, :notice => "Successfully created cycling team."
    else
      render :action => 'new'
    end
  end

  def edit
    @cycling_team = CyclingTeam.find(params[:id])
  end

  def update
    @cycling_team = CyclingTeam.find(params[:id])
    if @cycling_team.update_attributes(params[:cycling_team])
      redirect_to @cycling_team, :notice  => "Successfully updated cycling team."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @cycling_team = CyclingTeam.find(params[:id])
    @cycling_team.destroy
    redirect_to cycling_teams_url, :notice => "Successfully destroyed cycling team."
  end
end
