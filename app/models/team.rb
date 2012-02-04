class Team < ActiveRecord::Base
  MAXIMUM_SIZE = 20
  attr_accessor :budget

  belongs_to :user
  has_many :race_teams
  has_and_belongs_to_many :riders
  has_many :races, :through => :race_teams
  validates :name,  :presence => true, 
                    :uniqueness => true, 
                    :length => { :maximum => 100 },
                    :on => :create 

  validates :budget, :numericality => {:greater_than_or_equal_to => 0 } 
  validates :riders, :length => {:is => MAXIMUM_SIZE}
  
  def self.calculate_budget(riders)
    budget = 2000000
    riders.each { |rider| budget -= rider.value } unless riders.nil?
    return budget
  end

  def self.all_with_users
    self.includes(:user).order("points DESC").all
  end

  def is_second_overlapping_race_and_is_first_possible_race?(race)
    if Race.first_possible_race == race
      overlapping_race = race.find_earlier_overlapping_race
      if (!overlapping_race.nil? and !race_teams.empty?)
        return race_teams.first.race == race # if already exists 
      elsif (!overlapping_race.nil? and race_teams.empty?)
        return true
      end
      return false
    end
    return false
  end

  def has_race_team_for(race)
    return races.include?(race)
  end

  def get_race_team_for(race)
    return race_teams.reject { |race_team| race_team.race != race }.first
  end
end
