class MyTeamsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @teams = current_user.teams
  end

  def show
    @teams = current_user.teams.includes(:races,{:riders => :cycling_team})
    @team = @teams.select{|team| team.id.to_s == params[:team_id]}.first
    if @team.nil?
      not_allowed_to_view; return false;
    end
    @races = Race.all_except_stages
    @editable_races = @races.reject { |race| not race.possible_to_make_race_team(@races) }
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
