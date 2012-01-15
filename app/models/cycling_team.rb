class CyclingTeam < ActiveRecord::Base
  attr_accessible :name, :short_name, :active
  
  has_many :riders
end
