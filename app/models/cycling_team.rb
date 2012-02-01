class CyclingTeam < ActiveRecord::Base
  attr_accessible :name, :short_name, :active
  
  has_many :riders

  validates :name, :presence => true
  validates :short_name, :presence => true
end
