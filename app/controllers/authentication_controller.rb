class AuthenticationController < ApplicationController
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Je bent met succes ingelogd."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      options = {
        :provider => omniauth['provider'], 
        :uid => omniauth['uid'],
        :image_url => omniauth['info']['image'],
        :token => omniauth['credentials']['token']
      }
      if omniauth['provider'] == "twitter"
        options[:secret] = omniauth['credentials']['secret']
        options[:name] = omniauth['info']['nickname']
      elsif omniauth['provider'] == "facebook"
        options[:name] = omniauth['info']['name']
      end
      current_user.authentications.create!(options)
      flash[:notice] = "Je account is gekoppeld."
      redirect_to edit_user_registration_path
    else
      redirect_to root_path, :alert => "Dit #{omniauth['provider']} account is nog niet verbonden met megatombike. Dit moet je eerst instellen door gewoon in te loggen en je account toe te voegen via Mijn profiel."
    end
  end

  def use_this
    auths = current_user.authentications
    use_auth = Authentication.find(params[:auth_id])
    if auths.include?(use_auth)
      auths.each do |auth|
        if auth.id == use_auth.id
          auth.update_attribute(:use_as_picture, true)
        else
          auth.update_attribute(:use_as_picture, false)
        end
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Je account is met succes ontkoppeld."
    redirect_to edit_user_registration_path
  end
  
  def failure
    redirect_to root_path, :alert => "Er ging iets mis. Probeer later opnieuw"
  end
end
