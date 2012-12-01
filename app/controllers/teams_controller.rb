class TeamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin, :only => [:destroy]
  before_filter :can_subscribe_check, :only => [:new,:create]

  def index
    @teams = Team.all_with_users
  end

  def show
    @teams = Team.all_with_users
    @team = Team.where(:id => params[:id]).includes({:riders => :cycling_team},{:user => :authentications}).first
    respond_to do |format|
      format.js
      format.html { render "index"}
    end
  end

  def filter_period
      @period = Period.find(params[:period_id])
      @teams = Team.order_by_period(@period)
      render "index"
  end

  def filter_fb
    @teams = Team.all_with_users
    render "index" unless current_user
    users = get_fb_friends
    @teams = @teams.select { |team| users.include?(team.user) }
    @my_teams.each { |team| @teams << team }
    @teams.sort! {|x,y| y.points <=> x.points }
    render "index"
  end

  def filter_twt
    @teams = Team.all_with_users
    render "index" unless current_user
    users = get_twt_friends
    @teams = @teams.select { |team| users.include?(team.user) }
    @my_teams.each { |team| @teams << team }
    @teams.sort! {|x,y| y.points <=> x.points }
    render "index"
 end

  def new
    @team = Team.new
    @team.budget = 2000000
    @selected_riders = []
    @selected_riders_ids = []
    get_cycling_teams
  end

  def create
    @team = Team.new(:name => params[:team][:name])
    @team.riders = make_selection(params[:team])
    @team.budget = Team.calculate_budget(@team.riders)
    @team.user = current_user
    @selected_riders = @team.riders
    @selected_riders_ids = @selected_riders.collect { |rider| rider.id }
    get_cycling_teams
    if @team.save
      first_race = Race.first_possible_race
      redirect_to "/race_teams/new/#{@team.id}/race/#{first_race.id}", :notice => "Je ploeg is met succes opgeslagen."
    else
      render :action => 'new'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_url, :notice => "Je ploeg is met succes verwijderd."
  end

  def add_rider
    @selected_riders = make_selection(params,"add")
    @budget = Team.calculate_budget(@selected_riders)
    respond_to do |format|
      format.js { render "shared/update_selection", 
        :locals => {:team => "team", :riders_length => Team::MAXIMUM_SIZE}
      }
    end
  end

  def remove_rider
    @selected_riders = make_selection(params,"remove")
    @budget = Team.calculate_budget(@selected_riders)
    respond_to do |format|
      format.js { render "shared/update_selection", 
        :locals => {:team => "team", :riders_length => Team::MAXIMUM_SIZE}
      }
     end
  end
  
  private
  def make_selection(params, add_or_remove = "")
    riders_ids = []
    riders_ids = convert_string_array_to_int_array(params[:riders]) unless params[:riders].nil?
    rider_id = convert_string_to_int(params[:rider_id]) unless params[:rider_id].nil?
    if add_or_remove == "add"
      riders_ids << rider_id unless (riders_ids.include?(rider_id) or riders_ids.length >= Team::MAXIMUM_SIZE)
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

  def get_cycling_teams
    @cycling_teams = []
    @cycling_teams << CyclingTeam.new(:name => "Alle ploegen")
    CyclingTeam.where(:active => true).order("name ASC").all.each { |team| @cycling_teams << team }
  end
  
  def get_fb_friends
    fb_auth = current_user.authentications.select { |auth| auth.provider == 'facebook' }.first
    user = FbGraph::User.fetch(fb_auth.uid, :access_token => fb_auth.token)
    uids = user.friends.collect { |friend| friend.identifier }
    auths = Authentication.where("uid IN (:uids) and provider = :provider", {:uids => uids, :provider => 'facebook'}).all
    ids = auths.collect { |user| user.user_id }
    return User.where("id IN (:ids)", {:ids => ids}).all
  end

  def get_twt_friends
    twt_auth = current_user.authentications.select { |auth| auth.provider == 'twitter' }.first
    client = Twitter::Client.new(
      :oauth_token => twt_auth.token,
      :oauth_token_secret => twt_auth.secret
    )
    uids = client.friend_ids(twt_auth.uid.to_i).ids
    auths = Authentication.where("uid IN (:uids) and provider = :provider", {:uids => uids, :provider => 'twitter'}).all
    ids = auths.collect { |user| user.user_id }
    return User.where("id IN (:ids)", {:ids => ids}).all
  end
end
