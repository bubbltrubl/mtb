require 'calculation_engine.rb'

class ResultsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin, :only => [:new, :create]
  
  def index
    @new_result_races = Race.where(results_ready: false).all
    if params[:race_id]
      race = Race.find(params[:race_id])
    else
      race = Race.latest_available_result
    end
    if race.race.nil?
      @race = race
    else
      @race = race.race
    end
    get_previous_and_next_races(@race) unless @race.nil?
    show_results(race) unless @race.nil?
    @stages = @race.races.sort{ |x,y| x.date <=> y.date } if (!@race.nil? and @race.is_tour)
  end
  
  def new
    @race = Race.find(params[:race_id])
    if @race.results_ready
      redirect_to results_path, alert: 'Deze uitslag is al ingegeven.'
      return false
    end
  end
  
  def create
    @race = Race.find(params[:race_id])
    if @race.results_ready
      redirect_to results_path, alert: 'Deze uitslag is al ingegeven.'
      return false
    end
    rider_ids = []
    params[:result].values.each_index do |key|
      rider_ids << params[:result]["#{key}"][:rider_id].to_i
    end
    if @race.category.nr_of_riders != rider_ids.uniq.length
      redirect_to "/results/new/?race_id=#{@race.id}", alert: 'Er klopt iets niet met het aantal renners, probeer opnieuw.'
      return false
    else
      CalculationEngine::calculate(@race.id, rider_ids)
    end
  end
  
  private
  def show_results(race)
    if race.is_tour
      if race.results_ready
        race_or_stage = race
      else
        race_or_stage = race.latest_stage
      end
    else
      race_or_stage = race
    end
    unless race_or_stage.nil?
      @race_results = RaceResult.where(race_id: race_or_stage.id).includes(:rider => :cycling_team).order("race_results.position ASC")
      @team_results = TeamResult.where(race_id: race_or_stage.id).includes(:team => :user).order("team_results.points DESC, teams.id ASC")
      @stage = race_or_stage unless race_or_stage.race.nil?
    end
  end
  
  def get_previous_and_next_races race
    @previous_race = race.get_previous_race
    @next_race = race.get_next_race
  end
end
