module CalculationEngine
  def self.calculate race_id,riders_ids
    ActiveRecord::Base.transaction do
      begin
        # Get race
        race = Race.where(id: race_id).includes(:category).first
        # Get riders
        riders_array = Rider.where("id IN (:ids)",{:ids => riders_ids}).all
        # Add riders in correct order
        riders = []
        riders_ids.each do |rider_id|
          riders << riders_array.select { |rider| rider.id == rider_id }.first
        end
        # Parse points
        points = race.category.points_array
        # Save result => create race_results
        save_race_results(race,riders,points)
        # Give riders points => update rider.points
        update_rider_points(riders,points)
        # Get all teams
        teams = Team.all
        # Make hash of rider with points
        rider_points = make_rider_points(riders,points)
        # Get all race_teams
        race_teams = get_all_race_teams(race,teams)
        # Save team results => create team_results
        team_points = {}
        race_teams.each do |race_team|
          save_team_result_and_calculate_team_points(race, race_team,rider_points, team_points)
        end
        # Give teams points => update team.points
        teams.each do |team|
          update_team_points(team,team_points)
        end
        # Race results ready => race.results_ready = true
        race.update_attribute(:results_ready, true)
      rescue Exception => error
        raise ActiveRecord::Rollback
      end
    end
  end
  
  private
  
  def self.save_race_results race,riders,points
    riders.each_with_index do |rider,i|
      RaceResult.create!(
        :race_id => race.id,
        :rider_id => rider.id,
        :points => points[i],
        :position => i + 1
      )
    end
  end
  
  def self.update_rider_points riders,points
    riders.each_with_index do |rider,i|
      rider.update_attribute(:points, rider.points + points[i])
    end
  end
  
  def self.get_all_race_teams race,teams
    race_teams = []
    teams.each do |team|
      race_teams << RaceTeam.get_by_team_and_race(team,race)
    end
    return race_teams.delete_if { |race_team| race_team.nil? }
  end
  
  def self.make_rider_points riders, points
    rider_points = {}
    riders.each_with_index do |rider,i|
      rider_points[rider.id] = points[i]
    end
    return rider_points
  end
  
  def self.save_team_result_and_calculate_team_points race, race_team, rider_points, team_points
    points = 0
    race_team.riders.each do |rider|
      points += rider_points[rider.id] if rider_points.has_key?(rider.id)
    end
    if points > 0
      team_points[race_team.team_id] = points
      TeamResult.create!(
        :race_id => race.id,
        :team_id => race_team.team_id,
        :points => points
      )
    end
  end
  
  def self.update_team_points team, team_points
    if team_points.has_key?(team.id)
      team.update_attribute(:points, team.points + team_points[team.id])
    end
  end
end