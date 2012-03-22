class RegistrationsController < Devise::RegistrationsController
  before_filter :can_subscribe_check, :only => [:new,:create]
  protected

  def after_sign_up_path_for(resource)
    new_team_path
  end
end
