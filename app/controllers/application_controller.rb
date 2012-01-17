class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def admin
    unless current_user.try(:admin?)
      redirect_to :root, :notice => "Je hebt niet genoeg rechten om deze pagina te bezoeken"
      return false
    end
  end
end
