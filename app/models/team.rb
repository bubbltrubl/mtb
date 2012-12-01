class Team < ActiveRecord::Base
  MAXIMUM_SIZE = 20
  attr_accessor :budget

  belongs_to :user
  has_many :race_teams
  has_many :team_results
  has_and_belongs_to_many :riders
  has_many :races, :through => :race_teams
  validates :name,  :presence => true, 
                    :uniqueness => true, 
                    :length => { :maximum => 100 },
                    :on => :create 

  validates :budget, :numericality => {:greater_than_or_equal_to => 0 } 
  validates :riders, :length => {:is => MAXIMUM_SIZE}

  def points_for_period(period)
    points = 0
    team_results.select {|team_result| team_result.race.period == period}.each{|team_result| points += team_result.points }
    return points
  end
  
  def self.calculate_budget(riders)
    budget = 2000000
    riders.each { |rider| budget -= rider.value } unless riders.nil?
    return budget
  end

  def self.all_with_users
    self.includes(:user).order("points DESC").all
  end

  def self.order_by_period(period)
    self.includes(:user,{:team_results => {:race => :period}}).all.sort {|x,y| y.points_for_period(period) <=> x.points_for_period(period)}
  end
end
