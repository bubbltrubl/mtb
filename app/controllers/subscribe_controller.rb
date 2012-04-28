class SubscribeController < ApplicationController
  before_filter :authenticate_user!, :only => [:finished]

  def index
    respond_to do |format|
     format.mobile {
      if user_signed_in?
        redirect_to my_teams_path
      else 
        redirect_to new_user_session_path 
      end
     }
     format.html 
    end
  end

  def finished
    @user = current_user
  end

  def force_mobile
    session[:mobylette_override] = :force_mobile
    redirect_to root_url
  end

  def force_full
    session[:mobylette_override] = :ignore_mobile
    redirect_to root_url
  end
end
