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

  def self.get_by_team_and_race(team_id,race_id)
    race_team = RaceTeam.where(race_id: race_id, team_id: team_id).limit(1).first
    if race_team.nil?
      race = Race.find(race_id)
      race_team = RaceTeam.where("team_id = :team_id AND races.date < :date",
                          {:team_id => team_id, :date => race.date})
                          .joins(:race).order("races.date DESC").limit(1).first
      race_team = race_team.load_dependencies
      race_team = race_team.opposite unless race.possible_to_make_race_team(Race.all_except_stages)
    else
      race_team = race_team.load_dependencies
    end
    race_team 
  end

  def load_dependencies
    return RaceTeam.where(id: id).includes(:race,{:riders => :cycling_team}).limit(1).first
  end
end
