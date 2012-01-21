class MyTeamsController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :user_is_allowed_to_view_team, :only => [:show]
  
  def index
    @teams = current_user.teams
  end

  def show
    @teams = current_user.teams
    @team = @teams.select{|team| team.id.to_s == params[:team_id]}.first
    @races = Race.all #TODO: Race.race_or_tour
  end
end
