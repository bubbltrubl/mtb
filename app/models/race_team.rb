class RaceTeam < ActiveRecord::Base
  MAXIMUM_SIZE = 10

  belongs_to :race
  belongs_to :team
  belongs_to :user
  has_and_belongs_to_many :riders

  validates :riders, :length => {:is => MAXIMUM_SIZE}

  def opposite
    team_riders = team.riders
    opposite = RaceTeam.new(:race_id => self.race_id, :team_id => self.team_id)
    opposite.riders = team_riders.reject { |rider| self.riders.include?(rider) }
    opposite
  end
  
  def self.exists_for_race(race_teams,race)
    race_team = race_teams.select { |rt| rt.race_id == race.id }.first
    if race_team.nil?
      race_team = race_teams.select { |rt| rt.race.date < race.date }.sort { |x,y| y.race.date <=> x.race.date }.first
      return race_team.nil? ? false : true
    else
      return true
    end
  end

  def self.get_by_team_and_race(team,race)
    race_team = RaceTeam.where(race_id: race.id, team_id: team.id).limit(1).first
    if race_team.nil?
      race_team = RaceTeam.where("team_id = :team_id AND races.date < :date",
                          {:team_id => team.id, :date => race.date})
                          .joins(:race).order("races.date DESC").limit(1).first
      return nil if race_team.nil?
      race_team = race_team.load_dependencies
      race_team = race_team.opposite unless race.possible_to_make_race_team_without_date_check(Race.all_except_stages, team.race_teams)
    else
      race_team = race_team.load_dependencies
    end
    race_team
  end

  def load_dependencies
    return RaceTeam.where(id: id).includes(:riders).limit(1).first
  end
end
