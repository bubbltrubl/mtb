class MyTeamsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @teams = current_user.teams
    respond_to do |format|
      format.mobile {
        redirect_to "/my_teams/#{@teams.first.id}" if @teams.length == 1
      }
      format.html
    end
  end

  def show
    @teams = @my_teams
    if params[:race_id].nil?
      @team = Team.where(id: params[:team_id]).first
    else
      @team = Team.where(id: params[:team_id]).includes({:riders => :cycling_team}).first
    end
    if @team.nil?
      not_allowed_to_view; return false;
    end
    @race_teams = @team.race_teams.includes(:race).all
    @races = Race.all_except_stages.delete_if { |race| race.results_ready }
    @editable_races = Race.editable_races(@races, @race_teams)
    @first_possible_race = Race.first_possible_race
    show_race_team_specific unless params[:race_id].nil?
  end

  private
  def show_race_team_specific
    @race = @races.select{ |race| race.id.to_s == params[:race_id]}.first
    if @race.nil?
      not_allowed_to_view; return false;
    end
    @race_team = RaceTeam.get_by_team_and_race(@team, @race)
  end
end
