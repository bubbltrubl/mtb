class RaceTeam < ActiveRecord::Base
  belongs_to :race
  belongs_to :team
  has_and_belongs_to_many :riders
end
