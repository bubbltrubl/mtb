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

  # GET /race_teams/1
  # GET /race_teams/1.json
  def show
    @race_team = RaceTeam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @race_team }
    end
  end

  # GET /race_teams/new/1
  # GET /race_teams/new/1.json
  def new
    @team = Team.find(params[:team_id])
    @race = Race.find(params[:race_id])
    @race_team = RaceTeam.new(:team_id => @team.id, :race_id => @race.id)
    @selected_riders = {}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @race_team }
    end
  end

  # GET /race_teams/1/edit
  def edit
    @race_team = RaceTeam.find(params[:id])
  end

  # POST /race_teams
  # POST /race_teams.json
  def create
    @race_team = RaceTeam.new(params[:race_team])
    respond_to do |format|
      if @race_team.save
        format.html { redirect_to @race_team, notice: 'Race team was successfully created.' }
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
    respond_to do |format|
      if @race_team.update_attributes(params[:race_team])
        format.html { redirect_to @race_team, notice: 'Race team was successfully updated.' }
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
    @selected_riders = []
    params[:riders].each { |val| @selected_riders << val.to_i } unless params[:riders].nil?

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
