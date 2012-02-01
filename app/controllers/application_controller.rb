class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user_teams

  private

  def admin
    not_allowed_to_view unless current_user.try(:admin?)
  end

  def current_user_teams
    @my_teams = []
    if current_user.try(:teams)
      @my_teams = current_user.teams
    end
  end 

  def not_allowed_to_view
    redirect_to :root, :alert => "Je hebt niet genoeg rechten om deze pagina te bezoeken"
    return false
  end
end
