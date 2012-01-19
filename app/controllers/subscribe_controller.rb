class SubscribeController < ApplicationController
  before_filter :authenticate_user!, :only => [:finished]

  def index
  end

  def finished
    @user = current_user
  end
end
