class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin

  def index
    @teams = Team.includes(:user).order("users.id ASC").all   
  end

  def set_paid
    @team = Team.find(params[:team_id])
    @team.update_attribute(:paid, true)
    respond_to do |format|
      format.js { render "paid" }
    end 
  end

  def set_unpaid
    @team = Team.find(params[:team_id])
    @team.update_attribute(:paid, false)
    respond_to do |format|
      format.js { render "paid" }
    end
  end
end
