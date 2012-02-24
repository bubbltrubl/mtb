require 'calculation_engine.rb'

class ResultsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin, :only => [:new, :create]
  
  def index
    if params[:race_id]
      @race = Race.find(params[:race_id])
    else
      @race = Race.latest_available_result
    end
    get_previous_and_next_races(@race) unless @race.nil?
    show_results(@race) unless @race.nil?
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
      redirect_to "/results/new/#{@race.id}", alert: 'Er klopt iets niet met het aantal renners, probeer opnieuw.'
      return false
    else
      CalculationEngine::calculate(@race.id, rider_ids)
    end
  end
  
  private
  def show_results(race)
    @race_results = RaceResult.where(race_id: race.id).includes(:rider => :cycling_team).order("race_results.position ASC")
    @team_results = TeamResult.where(race_id: race.id).includes(:team => :user).order("team_results.points DESC, teams.id ASC")
  end
  
  def get_previous_and_next_races race
    @previous_race = Race.where("results_ready = :results_ready and date < :date and race_id IS :race_id", {:results_ready => true, :date => race.date, :race_id => nil }).order("date DESC").first
    @next_race = Race.where("results_ready = :results_ready and date > :date and race_id IS :race_id", {:results_ready => true, :date => race.date, :race_id => nil }).order("date ASC").first
  end
end
