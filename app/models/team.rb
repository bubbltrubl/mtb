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
  
  def self.calculate_budget(riders)
    budget = 2000000
    riders.each { |rider| budget -= rider.value } unless riders.nil?
    return budget
  end

  def self.all_with_users
    self.includes(:user).order("points DESC").all
  end
end
