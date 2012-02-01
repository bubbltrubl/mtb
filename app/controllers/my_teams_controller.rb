class MyTeamsController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :user_is_allowed_to_view_team, :only => [:show]
  
  def index
    @teams = current_user.teams
  end

  def show
    @teams = current_user.teams.includes(:races,{:riders => :cycling_team})
    @team = @teams.select{|team| team.id.to_s == params[:team_id]}.first
    @races = Race.all_except_stages
    @editable_races = @races.reject { |race| not race.possible_to_make_race_team(@races) }
    show_race_team_specific unless params[:race_id].nil?
  end

  private
  def show_race_team_specific
    @race_team = RaceTeam.get_by_team_and_race(@team.id, params[:race_id])
    @race = @races.select{ |race| race.id.to_s == params[:race_id]}.first
  end
end
