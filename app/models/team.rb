class Team < ActiveRecord::Base
  attr_accessor :budget

  belongs_to :user
  has_and_belongs_to_many :riders

  validates :name,  :presence => true, 
                    :uniqueness => true, 
                    :length => { :maximum => 100 }, 
                    :on => :create

  validates :budget, :numericality => {:greater_than_or_equal_to => 0 } 
  validates :riders, :length => {:is => 2}
  
  def self.calculate_budget(riders)
    budget = 2000000
    riders.each { |rider| budget -= rider.value } unless riders.nil?
    return budget
  end
end
