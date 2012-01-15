class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
    @team.budget = 2000000
    @selected_riders = {}
  end

  def create
    @team = Team.new(:name => params[:team][:name])
    @team.riders = make_selection(params[:team])
    @team.budget = Team.calculate_budget(@team.riders)
    @team.user = current_user
    @selected_riders = @team.riders
    if @team.save
      redirect_to root_url, :notice => "Succesfully created team."
    else
      render :action => 'new'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_url, :notice => "Succesfully destroyed cycling team."
  end

  def add_rider
    @selected_riders = make_selection(params,"add")
    @budget = Team.calculate_budget(@selected_riders)
    respond_to do |format|
      format.js { render "teams/update_selection"}
    end
  end

  def remove_rider
    @selected_riders = make_selection(params,"remove")
    @budget = Team.calculate_budget(@selected_riders)
    respond_to do |format|
      format.js { render "teams/update_selection" }
    end
  end
  
  private
  def make_selection(params, add_or_remove = "")
    riders_ids = []
    riders_ids = convert_string_array_to_int_array(params[:riders]) unless params[:riders].nil?
    rider_id = convert_string_to_int(params[:rider_id]) unless params[:rider_id].nil?
    if add_or_remove == "add"
      riders_ids << rider_id unless riders_ids.include?(rider_id)
    elsif add_or_remove == "remove"
      riders_ids.delete(rider_id) if riders_ids.include?(rider_id)
    end
    riders = Rider.where(:id => riders_ids).joins(:cycling_team).all
    return put_riders_in_correct_order(riders_ids,riders)
  end

  def put_riders_in_correct_order(riders_ids, riders)
    riders_in_correct_order =[]
    riders_ids.each do |rider_id|
      index = riders.index {|value| value.id == rider_id}
      riders_in_correct_order << riders[index]
    end
    riders_in_correct_order
  end

  def convert_string_array_to_int_array(string_array)
    string_array.collect { |str| convert_string_to_int(str)}
  end

  def convert_string_to_int(str)
    str.to_i
  end
end
