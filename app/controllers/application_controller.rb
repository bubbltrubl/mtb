class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user_teams
  before_filter :can_subscribe

  respond_to_mobile_requests

  private

  def admin
    not_allowed_to_view unless current_user.try(:admin?)
  end

  def current_user_teams
    @my_teams = []
    if current_user.try(:teams)
      @my_teams = current_user.teams.all
    end
  end
  
  def can_subscribe
    @can_subscribe = Race.can_subscribe?
  end

  def not_allowed_to_view
    redirect_to :root, :alert => "Je hebt niet genoeg rechten om deze pagina te bezoeken"
    return false
  end
  
  def can_subscribe_check
    unless @can_subscribe
      redirect_to :root, :alert => "De inschrijvingen zijn afgesloten."
      return false
    end
  end
end
