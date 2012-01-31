class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user_teams

  private

  def admin
    unless current_user.try(:admin?)
      redirect_to :root, :notice => "Je hebt niet genoeg rechten om deze pagina te bezoeken"
      return false
    end
  end

  def current_user_teams
    @my_teams = []
    if current_user.try(:teams)
      @my_teams = current_user.teams
    end
  end 
end
