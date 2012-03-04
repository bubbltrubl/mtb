class RaceTeamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin, :only => [:index,:destroy]

  # GET /race_teams
  # GET /race_teams.json
  def index
    @race_teams = RaceTeam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @race_teams }
    end
  end

  # GET /race_teams/new/1/race/2
  # GET /race_teams/new/1/race/2.json
  def new
    @redirect_to_my_teams = !params[:rdtmt].nil? ? "/rdtmt" : ""
    @team = Team.where(id: params[:team_id], user_id: current_user.id).limit(1).first
    if @team.nil?
      not_allowed_to_view; return false;
    end
    @race = Race.find(params[:race_id])
    unless @race.possible_to_make_race_team(Race.all_except_stages, @team.race_teams)
      redirect_to :back, :alert => "Je kan voor deze wedstrijd geen ploeg meer aanmaken"
      return false;
    end
    @race_team = RaceTeam.new(:team_id => @team.id, :race_id => @race.id)
    @selected_riders = []
    @selected_riders_ids = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @race_team }
    end
  end

  # GET /race_teams/1/edit
  def edit
    @race_team = RaceTeam.find(params[:id])
    @team = @race_team.team
    unless @team.user == current_user
      not_allowed_to_view; return false;
    end
    @race = @race_team.race
    unless @race.possible_to_make_race_team(Race.all_except_stages, @team.race_teams)
      redirect_to :back, :alert => "Je kan deze wedstrijdploeg niet meer wijzigen"
      return false
    end 
    @selected_riders = @race_team.riders
    @selected_riders_ids = @selected_riders.collect { |rider| rider.id }
  end

  # POST /race_teams/1/race/2
  # POST /race_teams/1/race/2.json
  def create
    @redirect_to_my_teams = !params[:rdtmt].nil? ? "/rdtmt" : ""
    @race_team = RaceTeam.new(:team_id => params[:team_id],
                              :race_id => params[:race_id])
    unless Team.find(params[:team_id]).user == current_user
      not_allowed_to_view; return false;
    end
    @race = Race.find(params[:race_id])
    @team = Team.find(params[:team_id])
    unless @race.possible_to_make_race_team(Race.all_except_stages, @team.race_teams)
      redirect_to :root, :alert => "Je kan voor deze wedstrijd geen ploeg meer aanmaken"
      return false;
    end
    @race_team.riders = make_selection(params[:race_team])
    @selected_riders = @race_team.riders
    @selected_riders_ids = @selected_riders.collect { |rider| rider.id }
    respond_to do |format|
      if @race_team.save
        format.html { 
          if @redirect_to_my_teams == "/rdtmt"
            redirect_to "/my_teams/#{@race_team.team_id}/race/#{@race_team.race_id}",
                        notice: 'Wedstrijdploeg is met succes aangemaakt.'
          else
            redirect_to '/subscribe/finished', 
                        notice: 'Wedstrijdploeg is met succes aangemaakt.' 
          end
        }
        format.json { render json: @race_team, status: :created, location: @race_team }
      else
        format.html { render action: "new" }
        format.json { render json: @race_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /race_teams/1
  # PUT /race_teams/1.json
  def update
    @race_team = RaceTeam.find(params[:id])
    unless @race_team.team.user == current_user
      not_allowed_to_view; return false;
    end
    @race = @race_team.race
    @team = @race_team.team
    unless @race.possible_to_make_race_team(Race.all_except_stages, @team.race_teams)
      redirect_to :root, :alert => "Je kan deze wedstrijdploeg niet meer wijzigen"
      return false
    end 
    @selected_riders = make_selection(params[:race_team])
    @selected_riders_ids = @selected_riders.collect { |rider| rider.id}
    respond_to do |format|
      if @race_team.update_attributes(:riders => @selected_riders)
        format.html { redirect_to "/my_teams/#{@race_team.team_id}/race/#{@race_team.race_id}", notice: 'De wedstrijdploeg is met succes gewijzigd.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @race_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /race_teams/1
  # DELETE /race_teams/1.json
  def destroy
    @race_team = RaceTeam.find(params[:id])
    @race_team.destroy
    respond_to do |format|
      format.html { redirect_to race_teams_url }
      format.json { head :ok }
    end
  end

  def add_rider
    @selected_riders = make_selection(params,"add")
    respond_to do |format|
      format.js { render "shared/update_selection", 
        :locals => {:team => "race_team", :riders_length => RaceTeam::MAXIMUM_SIZE}
      }
    end
  end

  def remove_rider
    @selected_riders = make_selection(params,"remove")
    respond_to do |format|
      format.js { render "shared/update_selection", 
        :locals => {:team => "race_team", :riders_length => RaceTeam::MAXIMUM_SIZE}
      }
    end
  end

  def update_chosen
    @team = Team.find(params[:team_id])
    @selected_riders_ids = []
    params[:riders].each { |val| @selected_riders_ids << val.to_i } unless params[:riders].nil?

    respond_to do |format|
      format.js
    end 
  end 
  
  private
  def make_selection(params, add_or_remove = "")
    riders_ids = []
    riders_ids = convert_string_array_to_int_array(params[:riders]) unless params[:riders].nil?
    rider_id = convert_string_to_int(params[:rider_id]) unless params[:rider_id].nil?
    if add_or_remove == "add"
      riders_ids << rider_id unless (riders_ids.include?(rider_id) or riders_ids.length >= RaceTeam::MAXIMUM_SIZE)
    elsif add_or_remove == "remove"
      riders_ids.delete(rider_id) if riders_ids.include?(rider_id)
    end
    riders = Rider.where(:id => riders_ids).joins(:cycling_team).includes(:cycling_team).all
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
